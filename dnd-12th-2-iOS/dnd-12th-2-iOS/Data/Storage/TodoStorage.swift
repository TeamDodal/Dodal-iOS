//
//  TodoStorage.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 5/12/25.
//

import Foundation
import CoreData

protocol TodoStorageType {
    func createTodoItem(title: String, content: String?, dueDate: Date?)
    func fetchTodoItems() throws -> [TodoItem]
    func fetchTodoItems(id: UUID) throws -> [TodoItem]
    func createSubTodoItem(id: UUID, title: String, content: String?, dueDate: Date?) throws
    func editTodoItem(id: UUID, title: String, content: String?, dueDate: Date?, isCompleted: Bool) throws
    func deleteTodoItem(id: UUID) throws -> Void
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
    
    func createTodoItem(title: String, content: String?, dueDate: Date?) {
        let context = persistentContainer.viewContext
        let newTodo = TodoItem(context: context)
        newTodo.id = UUID()
        newTodo.title = title
        newTodo.content = content
        newTodo.dueDate = dueDate
        newTodo.createDate = Date()
        newTodo.updateDate = Date()
        try? context.save()
    }
    
    func fetchTodoItems(id: UUID) throws -> [TodoItem] {
        do {
            let fetchRequest = NSFetchRequest<TodoItem>(entityName: modelName)
            fetchRequest.predicate = NSPredicate(format: "parent.id == %@", id as CVarArg)
            let data = try mainContext.fetch(fetchRequest)
            
            return data
        } catch {
            throw error
        }
    }
    
    func fetchTodoItems() throws -> [TodoItem] {
        do {
            let fetchRequest = NSFetchRequest<TodoItem>(entityName: modelName)
            fetchRequest.predicate = NSPredicate(format: "parent == nil")
            let data = try mainContext.fetch(fetchRequest)
            
            return data
        } catch {
            throw error
        }
    }
    
    func createSubTodoItem(id: UUID, title: String, content: String?, dueDate: Date?) throws {
        
        let fetchRequest = NSFetchRequest<TodoItem>(entityName: modelName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let data = try mainContext.fetch(fetchRequest)
            if let todo = data.first {
                let subTodo = TodoItem(context: mainContext)
                subTodo.id = UUID()
                subTodo.title = title
                subTodo.content = content
                subTodo.dueDate = dueDate
                subTodo.createDate = Date()
                subTodo.updateDate = Date()
                todo.addToItems(subTodo)
                
                do {
                    try? mainContext.save()
                } catch {}
            }
            
        } catch {
            throw error
        }
    }
    
    func editTodoItem(id: UUID, title: String, content: String?, dueDate: Date?, isCompleted: Bool) throws {
        let fetchRequest = NSFetchRequest<TodoItem>(entityName: modelName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let data = try mainContext.fetch(fetchRequest)
            if let todo = data.first {
                todo.id = id
                todo.title = title
                todo.content = content
                todo.dueDate = dueDate
                todo.updateDate = Date()
                todo.isCompleted = isCompleted
                do {
                    try mainContext.save()
                } catch {}
            }
            
        } catch {
            throw error
        }
    }
    
    func deleteTodoItem(id: UUID) throws {
        let fetchRequest = NSFetchRequest<TodoItem>(entityName: modelName)
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        do {
            let data = try mainContext.fetch(fetchRequest)
            if let todo = data.first {
                mainContext.delete(todo)
                try mainContext.save()
            }
        } catch {
            throw error
        }
    }
}


