//
//  CoreDataStorage.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 5/6/25.
//

import Foundation
import CoreData

protocol TodoStorageType {
    func creteTodoItem()
}

final class CoreDataStorage: TodoStorageType {
    
    private let modelName = "DodalModel"
    
    // container
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // context
    private var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func creteTodoItem() {
        guard let entity = NSEntityDescription.entity(forEntityName: "TodoItem", in: mainContext) else {
            return
        }
    }
}
