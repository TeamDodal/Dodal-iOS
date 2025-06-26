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
    var createTodoItem: (Todo) -> Void
    var createSubTodoItem: (_ id: UUID, _ todoItem: Todo) throws -> Void
    var editTodoItem: (Todo) throws -> Void
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
        createTodoItem: { todo in
            storage.createTodoItem(title: todo.title, content: todo.content, dueDate: todo.dueDate)
        },
        createSubTodoItem: { id, todo in
            do {
                try  storage.createSubTodoItem(id: id, title: todo.title, content: todo.content, dueDate: todo.dueDate)
            } catch {
                throw error
            }
            
        }, editTodoItem: { todo in
            do {
                try  storage.editTodoItem(id: todo.id, title: todo.title, content: todo.content, dueDate: todo.dueDate, isCompleted: todo.isCompleted)
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
