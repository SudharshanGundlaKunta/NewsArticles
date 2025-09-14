//
//  BookmarkViewController.swift
//  Articles
//
//  Created by Sudharshan on 12/09/25.
//

import UIKit

class BookmarkViewController: UIViewController {
    
    var bookmarkedArticles: [Article] = BookmarksViewModel.sharedInstance.getAllArticles()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var noBookmarksLbl: UILabel = {
        let lable = UILabel()
        lable.text = "No Bookmarks are available😥"
        lable.numberOfLines = 0
        lable.textAlignment = .center
        lable.font = .systemFont(ofSize: 24, weight: .semibold)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bookmarkedArticles = BookmarksViewModel.sharedInstance.getAllArticles()
        noBookmarksLbl.isHidden = bookmarkedArticles.count > 0
        self.tableView.reloadData()
    }
    
    private func setupUI() {
        title = "Bookmarks"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        addTableView()
        addLabel()
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
    
    private func addLabel() {
        self.view.addSubview(noBookmarksLbl)
        
        NSLayoutConstraint.activate([
            noBookmarksLbl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            noBookmarksLbl.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            noBookmarksLbl.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            noBookmarksLbl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    private func bookMark(article: Article) {
        BookmarksViewModel.sharedInstance.modifyArticles(article: article)
        bookmarkedArticles = BookmarksViewModel.sharedInstance.getAllArticles()
        noBookmarksLbl.isHidden = bookmarkedArticles.count > 0
        self.tableView.reloadData()
    }
}


extension BookmarkViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bookmarkedArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableCell.reuseIdentifier, for: indexPath) as? ArticleTableCell else {return UITableViewCell()}
        let article = self.bookmarkedArticles[indexPath.row]
        cell.populateData(article: article, isBookmarked: bookmarkedArticles.contains(where: {$0.title == article.title }))
        cell.bookMarkCallback = { [weak self] in
            self?.bookMark(article: article)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ArticleDetailsViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.article = bookmarkedArticles[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
