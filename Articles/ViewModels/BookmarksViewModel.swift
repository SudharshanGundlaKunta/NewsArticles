//
//  BookmarksViewModel.swift
//  Articles
//
//  Created by Sudharshan on 14/09/25.
//

import Foundation
import CoreData

class BookmarksViewModel {
    private var articles: [Article] = []
    static let sharedInstance = BookmarksViewModel()
    private init() {
        fetchBookmarkArticles()
    }
    
    func modifyArticles(article: Article) {
        if articles.contains(where: {$0.title == article.title}) {
            if let index = articles.firstIndex(where: {$0.title == article.title}){
                articles.remove(at: index)
            }
        }else {
            articles.append(article)
        }
        saveBookmarkArticlesToPersist(articles)
    }
    
    func getAllArticles() -> [Article] {
        return articles
    }
    
    func saveBookmarkArticlesToPersist(_ articles: [Article]) {
        let context = CoreDataManager.shared.context
        
        for article in articles {
            
            let fetchRequest: NSFetchRequest<BookmarkEntity> = BookmarkEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "title == %@", article.title ?? "")
            if let existing = try? context.fetch(fetchRequest), !existing.isEmpty {
                continue
            }
            
            let entity = BookmarkEntity(context: context)
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
    
    func fetchBookmarkArticles() {
        let context = CoreDataManager.shared.context
        let request: NSFetchRequest<BookmarkEntity> = BookmarkEntity.fetchRequest()
        
        do {
            let results = try context.fetch(request)
            self.articles = results.map { entity in
                Article(
                    source: Source(id: nil, name: ""),
                    author: entity.author,
                    title: entity.title,
                    description: entity.desc,
                    url: entity.url,
                    urlToImage: entity.urlToImage,
                    publishedAt: entity.publishedAt,
                    content: entity.content
                )
            }
        } catch {
            print(" Error fetching bookmarks: \(error)")
            self.articles = []
        }
    }
}
