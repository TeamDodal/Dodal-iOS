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
    func fetchTodoItems() throws -> [Todo]
    func fetchTodoItems(id: UUID) throws -> [Todo]
    func createSubTodoItem(id: UUID, title: String, content: String?, dueDate: Date?) throws
    func editTodoItem(id: UUID, title: String, content: String?, dueDate: Date?, isCompleted: Bool) throws
    func deleteTodoItem(id: UUID) throws -> Void
    func createOnboardingTodoItems(title: String, content: String?, dueDate: Date?) -> UUID
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
        context.perform {
            let newTodo = TodoItem(context: context)
            newTodo.id = UUID()
            newTodo.title = title
            newTodo.content = content
            newTodo.dueDate = dueDate
            newTodo.createDate = Date()
            newTodo.updateDate = Date()
            do {
                try context.save()
            } catch {
                print("Core Data save error: \(error)")
            }
        }
    }

    func fetchTodoItems() throws -> [Todo] {
        let context = persistentContainer.viewContext
        var dtos: [Todo] = []
        var fetchError: Error?
        context.performAndWait {
            do {
                let fetchRequest = NSFetchRequest<TodoItem>(entityName: modelName)
                let data = try context.fetch(fetchRequest)
                dtos = data.map { $0.toDto() }
            } catch {
                fetchError = error
            }
        }
        if let error = fetchError {
            throw error
        }
        return dtos
    }
    
    func fetchTodoItems(id: UUID) throws -> [Todo] {
        let context = persistentContainer.viewContext
        var dtos: [Todo] = []
        var fetchError: Error?
        context.performAndWait {
            do {
                let fetchRequest = NSFetchRequest<TodoItem>(entityName: modelName)
                fetchRequest.predicate = NSPredicate(format: "parent.id == %@", id as CVarArg)
                let data = try context.fetch(fetchRequest)
                dtos = data.map { $0.toDto() }
            } catch {
                fetchError = error
            }
        }
        if let error = fetchError {
            throw error
        }
        return dtos
    }
    
    func createSubTodoItem(id: UUID, title: String, content: String?, dueDate: Date?) throws {
        let context = persistentContainer.viewContext
        var opError: Error?
        context.performAndWait {
            let fetchRequest = NSFetchRequest<TodoItem>(entityName: modelName)
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            do {
                let data = try context.fetch(fetchRequest)
                if let todo = data.first {
                    let subTodo = TodoItem(context: context)
                    subTodo.id = UUID()
                    subTodo.title = title
                    subTodo.content = content
                    subTodo.dueDate = dueDate
                    subTodo.createDate = Date()
                    subTodo.updateDate = Date()
                    subTodo.parent = todo
                    todo.addToItems(subTodo)
                    try context.save()
                }
            } catch {
                opError = error
                print("Core Data error: \(error)")
            }
        }
        if let error = opError {
            throw error
        }
    }

    func editTodoItem(id: UUID, title: String, content: String?, dueDate: Date?, isCompleted: Bool) throws {
        let context = persistentContainer.viewContext
        var opError: Error?
        context.performAndWait {
            let fetchRequest = NSFetchRequest<TodoItem>(entityName: modelName)
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            do {
                let data = try context.fetch(fetchRequest)
                if let todo = data.first {
                    todo.title = title
                    todo.content = content
                    todo.dueDate = dueDate
                    todo.updateDate = Date()
                    todo.isCompleted = isCompleted
                    try context.save()
                }
            } catch {
                opError = error
                print("Core Data error: \(error)")
            }
        }
        if let error = opError {
            throw error
        }
    }

    func deleteTodoItem(id: UUID) throws {
        let context = persistentContainer.viewContext
        var opError: Error?
        context.performAndWait {
            let fetchRequest = NSFetchRequest<TodoItem>(entityName: modelName)
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            do {
                let data = try context.fetch(fetchRequest)
                if let todo = data.first {
                    context.delete(todo)
                    try context.save()
                }
            } catch {
                opError = error
                print("Core Data error: \(error)")
            }
        }
        if let error = opError {
            throw error
        }
    }

    func createOnboardingTodoItems(title: String, content: String?, dueDate: Date?) -> UUID {
        let context = persistentContainer.viewContext
        var newID: UUID = UUID()
        context.performAndWait {
            let newTodo = TodoItem(context: context)
            newID = UUID()
            newTodo.id = newID
            newTodo.title = title
            newTodo.content = content
            newTodo.dueDate = dueDate
            newTodo.createDate = Date()
            newTodo.updateDate = Date()
            do {
                try context.save()
            } catch {
                print("Core Data save error: \(error)")
            }
        }
        return newID
    }
}
