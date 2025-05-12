//
//  TodoListView.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 5/12/25.
//

import SwiftUI

import ComposableArchitecture

struct TodoListView: View {
    private let store: StoreOf<TodoListFeature>
    
    init(store: StoreOf<TodoListFeature>) {
        self.store = store
    }
    
    var body: some View {
        WithPerceptionTracking {
            List(store.todoItems, id: \.self) { todo in
                Text(todo.title ?? "")
                    .onTapGesture {
                        store.send(.view(.todoCellTapped(todo)))
                    }
            }
            .onAppear {
                store.send(.view(.viewonAppear))
            }
        }
    }
}

//#Preview {
//    TodoListView(store: .init(initialState: TodoList, reducer: <#T##() -> Reducer#>))
//}
