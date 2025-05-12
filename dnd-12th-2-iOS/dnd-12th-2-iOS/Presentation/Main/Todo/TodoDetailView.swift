//
//  TodoDetailView.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 5/12/25.
//

import SwiftUI

import ComposableArchitecture

struct TodoDetailView: View {
    @Perception.Bindable private var store: StoreOf<TodoDetailFeature>
    
    init(store: StoreOf<TodoDetailFeature>) {
        self.store = store
    }
    var body: some View {
        WithPerceptionTracking {
            VStack {
                Text(store.todo.title)
                Text("path: \(store.todo.parent?.title ?? "root")")
                    .foregroundStyle(.gray)
                if let subTodo = store.todo.items {
                    List(Array(subTodo), id: \.self) {
                        Text("title: \($0.title)")
                    }
                }
            }
            .overlay(alignment: .bottom) {
                Button(action: {
                    store.send(.showAddTodoButtonTapped)
                }, label: {
                    Text("SubTodo 추가")
                })
            }
            .sheet(isPresented: $store.isShowAddTodoSheet) {
                AddTodoView(store: .init(initialState: TodoFeature.State(parentId: store.todo.id), reducer: {
                    TodoFeature()
                }))
            }
        }
    }
}

//#Preview {
//    TodoDetailView()
//}
