//
//  ArticleDetailsViewController.swift
//  Articles
//
//  Created by Sudharshan on 14/09/25.
//

import UIKit
import Kingfisher

class ArticleDetailsViewController: UIViewController {
    
    var article: Article?
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageBgView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "news"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var headlineLbl: UILabel = {
        let lable = UILabel()
        lable.text = "hhddkdl"
        lable.numberOfLines = 0
        lable.font = .systemFont(ofSize: 16, weight: .semibold)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    private lazy var subHeadlineLbl: UILabel = {
        let lable = UILabel()
        lable.text = "skjdbf"
        lable.numberOfLines = 0
        lable.textColor = .gray
        lable.font = .systemFont(ofSize: 14, weight: .medium)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News Details"
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    private func setupUI() {
        addScrollView()
        addContentView()
        addImageView()
        addHeadline()
        addSubHeadline()
        populateData()
    }
    
    private func addScrollView() {
        self.view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    private func addContentView() {
        self.scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func addImageView() {
        self.contentView.addSubview(imageBgView)
        
        NSLayoutConstraint.activate([
            imageBgView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            imageBgView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            imageBgView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 24),
            imageBgView.heightAnchor.constraint(equalToConstant: 250),
        ])
    }
    
    private func addHeadline() {
        self.contentView.addSubview(headlineLbl)
        
        NSLayoutConstraint.activate([
            headlineLbl.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 24),
            headlineLbl.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -24),
            headlineLbl.topAnchor.constraint(equalTo: self.imageBgView.bottomAnchor, constant: 24),
        ])
    }
    
    private func addSubHeadline() {
        self.contentView.addSubview(subHeadlineLbl)
        
        NSLayoutConstraint.activate([
            subHeadlineLbl.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 24),
            subHeadlineLbl.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -24),
            subHeadlineLbl.topAnchor.constraint(equalTo: self.headlineLbl.bottomAnchor, constant: 16),
            subHeadlineLbl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
    
    private func populateData() {
        if let url = URL(string: article?.urlToImage ?? "") {
            self.imageBgView.kf.setImage(with: url)
        }
        
        self.headlineLbl.text = article?.title
        self.subHeadlineLbl.text = (article?.description ?? "") + "\n" + "\(article?.content ?? "")" + "\n\n" + "Author : \(article?.author ?? "Unknown")" + "\n\n" + "For more info:  " + "\(article?.url ?? "-")" + "\n\n" + "Published at: \(article?.publishedAt ?? "-")"
    }
    
}

