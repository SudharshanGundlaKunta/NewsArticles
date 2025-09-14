//
//  CoreDataManager.swift
//  Articles
//
//  Created by Sudharshan on 14/09/25.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    lazy var persistentContainer: NSPersistentContainer = {
        let model = NSManagedObjectModel()
        let articleEntity = createEntity(
            name: "ArticleEntity",
            managedObjectClass: ArticleEntity.self
        )
        let bookmarkEntity = createEntity(
            name: "BookmarkEntity",
            managedObjectClass: BookmarkEntity.self
        )
        model.entities = [articleEntity, bookmarkEntity]

        let container = NSPersistentContainer(name: "Articles", managedObjectModel: model)
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError(" Core Data stack failed: \(error)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }

    private func createEntity(name: String, managedObjectClass: AnyClass) -> NSEntityDescription {
        let entity = NSEntityDescription()
        entity.name = name
        entity.managedObjectClassName = NSStringFromClass(managedObjectClass)

        var properties = [NSAttributeDescription]()

        let attributes = ["title", "author", "desc", "url", "urlToImage", "publishedAt", "content"]

        for attrName in attributes {
            let attr = NSAttributeDescription()
            attr.name = attrName
            attr.attributeType = .stringAttributeType
            attr.isOptional = true
            properties.append(attr)
        }

        entity.properties = properties
        return entity
    }
}
