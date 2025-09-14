//
//  BookmarkEntity.swift
//  Articles
//
//  Created by Sudharshan on 14/09/25.
//

import Foundation
import CoreData

@objc(BookmarkEntity)
class BookmarkEntity: NSManagedObject {
    @NSManaged var title: String?
    @NSManaged var author: String?
    @NSManaged var url: String?
    @NSManaged var desc: String?
    @NSManaged var urlToImage: String?
    @NSManaged var publishedAt: String?
    @NSManaged var content: String?
}

extension BookmarkEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookmarkEntity> {
        return NSFetchRequest<BookmarkEntity>(entityName: "BookmarkEntity")
    }
}
