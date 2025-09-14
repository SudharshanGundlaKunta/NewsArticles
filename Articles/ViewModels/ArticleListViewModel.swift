//
//  ArticleListViewModel.swift
//  Articles
//
//  Created by Sudharshan on 14/09/25.
//


import CoreData

class ArticleListViewModel {
    
    var articles: [Article] = []
    var bookmarkedArticles: [Article] = BookmarksViewModel.sharedInstance.getAllArticles()
    var refreshCallback: (() -> ())?
    
    init(articles: [Article] = [], bookmarkedArticles: [Article] = [], refreshCallback: ( () -> Void)? = nil) {
        self.articles = articles
        self.bookmarkedArticles = bookmarkedArticles
        self.refreshCallback = refreshCallback
        
        fetchArticles()
    }
    
    func fetchArticles() {
        NetworkService.shared.fetchArticles(from: "https://newsapi.org/v2/top-headlines?country=us&apiKey=75dd7f7b413c45849f31c42caa3605ee") { result in
            switch result {
            case .success(let data):
                self.articles = data.articles ?? []
                
                if let fetchedArticles = data.articles {
                    self.saveArticlesToPersist(fetchedArticles)
                }
                
                self.refreshCallback?()
                
            case .failure(let error):
                print("API failed: \(error)")
                self.articles = self.fetchSavedArticles()
                self.refreshCallback?()
            }
        }
    }
    
    func saveArticlesToPersist(_ articles: [Article]) {
        let context = CoreDataManager.shared.context
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ArticleEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch {
            print("Failed to clear old articles: \(error)")
        }
        
        for article in articles {
            let entity = ArticleEntity(context: context)
            entity.author = article.author
            entity.title = article.title
            entity.desc = article.description
            entity.url = article.url
            entity.urlToImage = article.urlToImage
            entity.publishedAt = article.publishedAt
            entity.content = article.content
        }
        
        CoreDataManager.shared.saveContext()
    }
    
    func fetchSavedArticles() -> [Article] {
        let context = CoreDataManager.shared.context
        let request: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        
        do {
            let results = try context.fetch(request)
            return results.map {
                Article(
                    source: Source(id: nil, name: ""), // Core Data doesn’t store Source, use placeholder
                    author: $0.author,
                    title: $0.title,
                    description: $0.desc,
                    url: $0.url,
                    urlToImage: $0.urlToImage,
                    publishedAt: $0.publishedAt,
                    content: $0.content
                )
            }
        } catch {
            print("Error fetching saved articles: \(error)")
            return []
        }
    }


}

