//
//  SearchViewController.swift
//  Articles
//
//  Created by Sudharshan on 14/09/25.
//

import UIKit

class SearchViewController: UIViewController {
    
    var allArticles: [Article] = []
    var articles: [Article] = []
    var bookmarkedArticles: [Article] = BookmarksViewModel.sharedInstance.getAllArticles()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var searchBar = {
        let searchBar = UISearchBar()
        searchBar.frame = CGRect(x: 0, y: 0, width: 200, height: 70)
        searchBar.delegate = self
        searchBar.showsCancelButton = false
        searchBar.searchBarStyle = UISearchBar.Style.minimal
        searchBar.placeholder = " Search Here....."
        searchBar.sizeToFit()
        return searchBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bookmarkedArticles = BookmarksViewModel.sharedInstance.getAllArticles()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder() 
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.resignFirstResponder()
    }
    
    private func setupUI() {
        title = "Search"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        addTableView()
        addSearchBar()
    }
    
    private func addTableView() {
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ArticleTableCell.self, forCellReuseIdentifier: ArticleTableCell.reuseIdentifier)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    private func addSearchBar() {
        tableView.tableHeaderView = searchBar
    }
    
    private func bookMark(article: Article) {
        BookmarksViewModel.sharedInstance.modifyArticles(article: article)
        bookmarkedArticles = BookmarksViewModel.sharedInstance.getAllArticles()
        self.tableView.reloadData()
    }

}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableCell.reuseIdentifier, for: indexPath) as? ArticleTableCell else {return UITableViewCell()}
        let article = self.articles[indexPath.row]
        cell.populateData(article: article, isBookmarked: bookmarkedArticles.contains(where: {$0.title == article.title }))
        cell.bookMarkCallback = { [weak self] in
            self?.bookMark(article: article)
        }
        return cell
    }

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            articles = allArticles
        } else {
            articles = allArticles.filter { article in
                article.title?.range(of: searchText, options: .caseInsensitive) != nil
            }
        }
        tableView.reloadData()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        articles = allArticles
        tableView.reloadData()
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}
