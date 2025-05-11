//
//  CoreDataStorage.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 5/6/25.
//

import Foundation
import CoreData

protocol TodoStorageType {
    func creteTodoItem(title: String?, content: String?, dueDate: Date?)
    func fetchTodoItems()
}

final class CoreDataStorage: TodoStorageType {
    
    static let shared = CoreDataStorage()
    private init() {}
    
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
    
    func creteTodoItem(title: String?, content: String?, dueDate: Date?) {
        let context = persistentContainer.viewContext
        let newTodo = TodoItem(context: context)
        newTodo.id = UUID()
        newTodo.title = title
        newTodo.content = content
        newTodo.dueDate = dueDate
        try? context.save()
    }
    
    func fetchTodoItems() {
        
    }
}
