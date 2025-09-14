//
//  ArticleListViewController.swift
//  Articles
//
//  Created by Sudharshan on 12/09/25.
//

import UIKit

class ArticleListViewController: UIViewController {
    
    var articleListViewModel = ArticleListViewModel()
    
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
        self.navigationController?.navigationBar.prefersLargeTitles = true
        articleListViewModel.bookmarkedArticles = BookmarksViewModel.sharedInstance.getAllArticles()
        tableView.reloadData()
    }
    
    private func setupUI() {
        setupNavBar()
        addTableView()
        addSearchBar()
        bindViewModel()
    }
    
    private func setupNavBar() {
        title = "News"
        
        let button = UIBarButtonItem(
            image: UIImage(systemName: "moon.fill"),
            style: .plain,
            target: self,
            action: #selector(toggleTheme)
        )
        button.tintColor = .label
        navigationItem.rightBarButtonItem = button
        
    }
    
    
    private func addTableView() {
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
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
    
    @objc private func callPullToRefresh() {
        self.tableView.refreshControl?.beginRefreshing()
        articleListViewModel.fetchArticles()
    }
    
    private func bookMark(article: Article) {
        BookmarksViewModel.sharedInstance.modifyArticles(article: article)
        articleListViewModel.bookmarkedArticles = BookmarksViewModel.sharedInstance.getAllArticles()
        self.tableView.reloadData()
    }
    
    @objc private func navigateToSearch() {
        let vc = SearchViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.allArticles = articleListViewModel.articles
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func bindViewModel() {
        articleListViewModel.refreshCallback = { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self?.tableView.refreshControl?.endRefreshing()
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc private func toggleTheme() {
        guard let window = UIApplication.shared.windows.first else { return }
            
            if window.overrideUserInterfaceStyle == .dark {
                window.overrideUserInterfaceStyle = .light
                navigationItem.rightBarButtonItem?.image = UIImage(systemName: "moon.fill")?.withTintColor(.black)
            } else {
                window.overrideUserInterfaceStyle = .dark
                navigationItem.rightBarButtonItem?.image = UIImage(systemName: "sun.max.fill")?.withTintColor(.yellow)
            }
    }
}

extension ArticleListViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articleListViewModel.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableCell.reuseIdentifier, for: indexPath) as? ArticleTableCell else {return UITableViewCell()}
        let article = articleListViewModel.articles[indexPath.row]
        cell.populateData(article: article, isBookmarked: articleListViewModel.bookmarkedArticles.contains(where: {$0.title == article.title }))
        cell.bookMarkCallback = { [weak self] in
            self?.bookMark(article: article)
        }
        return cell
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.resignFirstResponder()
        navigateToSearch()
        return false
    }
    
}
