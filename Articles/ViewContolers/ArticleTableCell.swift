//
//  ArticleTableCell.swift
//  Articles
//
//  Created by Sudharshan on 12/09/25.
//

import UIKit
import Kingfisher

class ArticleTableCell: UITableViewCell {
    
    static let reuseIdentifier = "ArticleTableCell"
    var bookMarkCallback: (() -> ())?
    
    private lazy var bgView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 24.0
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.separator.cgColor
        return view
    }()
    
    private lazy var imageBgView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "news"))
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 24.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var bookmarkImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "bookmark")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onBookmarkclick))
        image.addGestureRecognizer(tapGesture)
        return image
    }()
    
    private lazy var headlineLbl: UILabel = {
        let lable = UILabel()
        lable.text = ""
        lable.numberOfLines = 0
        lable.font = .systemFont(ofSize: 16, weight: .semibold)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    private lazy var subHeadlineLbl: UILabel = {
        let lable = UILabel()
        lable.text = ""
        lable.numberOfLines = 2
        lable.textColor = .gray
        lable.font = .systemFont(ofSize: 12, weight: .regular)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addAllSubView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addAllSubView() {
        addBgView()
        addImageView()
        addHeaderLabel()
        addSubHeadlineLbl()
        addBookmarkImageView()
    }
    
    private func addBgView() {
        contentView.addSubview(bgView)
        
        NSLayoutConstraint.activate([
            bgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            bgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            bgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
    
    private func addImageView() {
        bgView.addSubview(imageBgView)
        
        NSLayoutConstraint.activate([
            imageBgView.leadingAnchor.constraint(equalTo: bgView.leadingAnchor),
            imageBgView.trailingAnchor.constraint(equalTo: bgView.trailingAnchor),
            imageBgView.topAnchor.constraint(equalTo: bgView.topAnchor),
            imageBgView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func addHeaderLabel() {
        bgView.addSubview(headlineLbl)
        
        NSLayoutConstraint.activate([
            headlineLbl.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 16),
            headlineLbl.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -16),
            headlineLbl.topAnchor.constraint(equalTo: imageBgView.bottomAnchor, constant: 16),
        ])
    }
    
    private func addSubHeadlineLbl() {
        bgView.addSubview(subHeadlineLbl)
        bgView.addSubview(bookmarkImageView)
        
        NSLayoutConstraint.activate([
            subHeadlineLbl.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 16),
            subHeadlineLbl.trailingAnchor.constraint(lessThanOrEqualTo: bookmarkImageView.leadingAnchor, constant: -8),
            subHeadlineLbl.topAnchor.constraint(equalTo: headlineLbl.bottomAnchor, constant: 8),
            subHeadlineLbl.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -16),
        ])
    }
    
    private func addBookmarkImageView() {
        
        NSLayoutConstraint.activate([
            bookmarkImageView.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -12),
            bookmarkImageView.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -16),
            bookmarkImageView.heightAnchor.constraint(equalToConstant: 24),
            bookmarkImageView.widthAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    func populateData(article: Article, isBookmarked: Bool) {
        self.headlineLbl.text = article.title
        self.subHeadlineLbl.text = article.description
        self.bookmarkImageView.image = isBookmarked ? UIImage(systemName: "bookmark.fill")?.withTintColor(.blue) : UIImage(systemName: "bookmark")
        if let url = URL(string: article.urlToImage ?? "") {
            self.imageBgView.kf.setImage(with: url)
        }
    }
    
    @objc private func onBookmarkclick() {
        bookMarkCallback?()
    }

}
