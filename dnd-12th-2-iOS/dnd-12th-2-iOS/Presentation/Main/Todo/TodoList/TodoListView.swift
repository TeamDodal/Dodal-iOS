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
            ScrollView {
                VStack(spacing: 12) {
                    DDTodoCardList(title:"마감일까지 d-1", todos: store.todoItems) { todo in
                        
                    }
                    DDTodoCardList(title:"이번주", todos: store.todoItems) { todo in
                        
                    }
                    DDTodoCardList(title:"최근", todos: store.todoItems) { todo in
                        
                    }
                }
                .padding(.top, 8)
                .padding(.horizontal, 16)
            }
            .background(.gray50)
            .onAppear {
                store.send(.view(.viewonAppear))
            }
        }
    }
}

//#Preview {
//    TodoListView(store: .init(initialState: TodoList, reducer: <#T##() -> Reducer#>))
//}
