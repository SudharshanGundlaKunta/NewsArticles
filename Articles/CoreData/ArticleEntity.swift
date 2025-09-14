//
//  ArticleEntity.swift
//  Articles
//
//  Created by Sudharshan on 14/09/25.
//

import Foundation
import CoreData

@objc(ArticleEntity)
public class ArticleEntity: NSManagedObject {
    @NSManaged public var title: String?
    @NSManaged public var author: String?
    @NSManaged public var desc: String?
    @NSManaged public var url: String?
    @NSManaged public var urlToImage: String?
    @NSManaged public var publishedAt: String?
    @NSManaged public var content: String?
}

extension ArticleEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleEntity> {
        return NSFetchRequest<ArticleEntity>(entityName: "ArticleEntity")
    }
}
