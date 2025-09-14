//
//  ViewController.swift
//  Articles
//
//  Created by Sudharshan on 12/09/25.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let articleNVC = UINavigationController(rootViewController: ArticleListViewController())
        articleNVC.tabBarItem = UITabBarItem(title: "News", image: UIImage(systemName: "newspaper"), tag: 0)
        
        let bookmarkNVC = UINavigationController(rootViewController: BookmarkViewController())
        bookmarkNVC.tabBarItem = UITabBarItem(title: "Bookmarks", image: UIImage(systemName: "bookmark"), tag: 1)
        
        UITabBar.appearance().backgroundColor = .white
        UITabBar.appearance().layer.borderWidth = 1.0
        UITabBar.appearance().layer.borderColor = UIColor.gray.cgColor
        
        viewControllers = [articleNVC, bookmarkNVC]
    }
}
