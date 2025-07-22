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
    var createOnboardingTodoItems: (_ title: String, _ content: String?, _ dueDate: Date?) -> UUID
    var createTodoWithSubTodos: (_ title: String, _ subTasks: [String]) throws -> Void
    var deleteTodoItem: (_ id: UUID) throws -> Void
    
    static let storage = TodoStorage.shared
}

extension TodoClient: DependencyKey {
    static let liveValue = Self (
        fetchTodoItems: {
            try storage.fetchTodoItems() // <-- 바로 반환
        },
        fetchSubTodoItems: { id in
            try storage.fetchTodoItems(id: id) // <-- 바로 반환
        },
        createTodoItem: { todo in
            storage.createTodoItem(title: todo.title, content: todo.content, dueDate: todo.dueDate)
        },
        createSubTodoItem: { id, todo in
            try storage.createSubTodoItem(id: id, title: todo.title, content: todo.content, dueDate: todo.dueDate)
        },
        editTodoItem: { todo in
            try storage.editTodoItem(id: todo.id, title: todo.title, content: todo.content, dueDate: todo.dueDate, isCompleted: todo.isCompleted)
        },
        createOnboardingTodoItems: { title, content, dueDate in
            storage.createOnboardingTodoItems(title: title, content: content, dueDate: dueDate)
        },
        createTodoWithSubTodos: { title, subTasks in
            let parentID = storage.createOnboardingTodoItems(title: title, content: nil, dueDate: nil)
            for task in subTasks where !task.isEmpty {
                try storage.createSubTodoItem(id: parentID, title: task, content: nil, dueDate: nil)
            }
        },
        deleteTodoItem: { id in
            try storage.deleteTodoItem(id: id)
        }
    )
}


extension DependencyValues {
    var todoClient: TodoClient {
        get { self[TodoClient.self] }
        set { self[TodoClient.self] = newValue }
    }
}
