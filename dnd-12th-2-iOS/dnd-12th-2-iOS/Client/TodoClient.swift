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
    var createTodoItem: (_ title: String?, _ content: String?, _ dueDate: Date?) -> Void
    
    static let storage = CoreDataStorage.shared
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
        }
    )
}

extension DependencyValues {
    var todoClient: TodoClient {
        get { self[TodoClient.self] }
        set { self[TodoClient.self] = newValue }
    }
}
