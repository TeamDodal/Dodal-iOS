//
//  TodoClient.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 5/12/25.
//

import Foundation

import ComposableArchitecture

struct TodoClient {
    var fetchTodoItems: () throws -> [TodoItem]
    var createTodoItem: (_ title: String, _ content: String?, _ dueDate: Date?) -> Void
    var createSubTodoItem: (_ id: UUID, _ title: String, _ content: String?, _ dueDate: Date?) throws -> Void
    var editTodoItem: (_ id: UUID, _ title: String, _ content: String?, _ dueDate: Date?) throws -> Void
    
    static let storage = TodoStorage.shared
}

extension TodoClient: DependencyKey {
    static let liveValue = Self (
        fetchTodoItems: {
            do {
                return try storage.fetchTodoItems()
            } catch {
                throw error
            }
        },
        createTodoItem: { title, content, dueDate in
            storage.creteTodoItem(title: title, content: content, dueDate: dueDate)
        },
        createSubTodoItem: { id, title, content, dueDate in
            do {
                try  storage.createSubTodoItem(id: id, title: title, content: content, dueDate: dueDate)
            } catch {
                throw error
            }
            
        }, editTodoItem: { id, title, content, dueDate in
            do {
                try  storage.editTodoItem(id: id, title: title, content: content, dueDate: dueDate)
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
