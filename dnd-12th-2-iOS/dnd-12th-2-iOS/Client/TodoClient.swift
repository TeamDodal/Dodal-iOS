//
//  TodoClient.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 5/12/25.
//

import Foundation

import ComposableArchitecture

struct TodoClient {
    var fetchTodoItems: () throws -> [Todo]
    var fetchSubTodoItems: (_ id: UUID) throws -> [Todo]
    var createTodoItem: (_ title: String, _ content: String?, _ dueDate: Date?) -> Void
    var createSubTodoItem: (_ id: UUID, _ title: String, _ content: String?, _ dueDate: Date?) throws -> Void
    var createOnboardingTodoItems: (_ title: String, _ content: String?, _ dueDate: Date?) -> UUID
    var createTodoWithSubTodos: (_ title: String, _ subTasks: [String]) throws -> Void
    var editTodoItem: (_ id: UUID, _ title: String, _ content: String?, _ dueDate: Date?, _ isCompleted: Bool) throws -> Void
    var deleteTodoItem: (_ id: UUID) throws -> Void
    
    static let storage = TodoStorage.shared
}

extension TodoClient: DependencyKey {
    static let liveValue = Self (
        fetchTodoItems: {
            do {
                return try storage.fetchTodoItems().map { $0.toDto() }
            } catch {
                throw error
            }
        },
        fetchSubTodoItems: { id in
            do {
                return try storage.fetchTodoItems(id: id).map { $0.toDto() }
            } catch {
                throw error
            }
        },
        createTodoItem: { title, content, dueDate in
            storage.createTodoItem(title: title, content: content, dueDate: dueDate)
        },
        createSubTodoItem: { id, title, content, dueDate in
            do {
                try  storage.createSubTodoItem(id: id, title: title, content: content, dueDate: dueDate)
            } catch {
                throw error
            }
            
        }, createOnboardingTodoItems: { title, content, dueDate in
            return storage.createOnboardingTodoItems(title: title, content: content, dueDate: dueDate)
        }, createTodoWithSubTodos: { title, subTasks in
            let parentID = storage.createOnboardingTodoItems(title: title, content: nil, dueDate: nil)
            
            for task in subTasks where !task.isEmpty {
                try storage.createSubTodoItem(id: parentID, title: task, content: nil, dueDate: nil)
            }
        }, editTodoItem: { id, title, content, dueDate, isCompleted in
            do {
                try  storage.editTodoItem(id: id, title: title, content: content, dueDate: dueDate, isCompleted: isCompleted)
            } catch {
                throw error
            }
        },
        deleteTodoItem: { id in
            do {
                try  storage.deleteTodoItem(id: id)
            } catch {
                throw error
            }
        }
    )
}

extension DependencyValues {
    var todoClient: TodoClient {
        get { self[TodoClient.self] }
        set { self[TodoClient.self] = newValue }
    }
}
