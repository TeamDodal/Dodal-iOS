//
//  TodoStorage.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 5/12/25.
//

import Foundation
import CoreData

protocol TodoStorageType {
    func creteTodoItem(title: String?, content: String?, dueDate: Date?)
    func fetchTodoItems() throws -> [TodoItem]
}

final class TodoStorage: TodoStorageType {
    
    static let shared = TodoStorage()
    private init() {}
    
    private let modelName = "TodoItem"
    private let containerName = "DodalModel"
    
    // container
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: containerName)
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
    
    func fetchTodoItems() throws -> [TodoItem] {
        do {
            let fetchRequest = NSFetchRequest<TodoItem>(entityName: modelName)
            let data = try mainContext.fetch(fetchRequest)
            
            return data
        } catch {
            throw error
        }
    }
}


