//
//  CoreDataManager.swift
//  PhotosMVVM
//
//  Created by 민선기 on 2022/05/28.
//

import Foundation
import UIKit
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }

    
    func get() -> [PhotoCoreData] {
        do {
            let items = try context.fetch(PhotoCoreData.fetchRequest())
            return items
        } catch {
            print(error)
            return []
        }
    }
    
    func save(model: Photo) {
        let newItem = PhotoCoreData(context: context)
        newItem.id = model.id
        newItem.imagePath = model.imagePath
        newItem.isFavorite = true
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func delete(id: String) {
        let items = get()
        items.forEach {
            if $0.id == id {
                context.delete($0)
            }
        }
        do {
            try context.save()
        } catch{
            print(error)
        }
    }
}
