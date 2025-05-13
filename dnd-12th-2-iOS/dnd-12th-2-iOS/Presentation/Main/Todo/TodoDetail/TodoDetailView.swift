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
                HStack {
                    Spacer()
                    Text(store.todoItem.title)
                    Spacer()
                    Button(action: {
                        store.send(.view(.deleteButtonTapped))
                    }, label: {
                        Image(systemName: "trash")
                    })
                    Button(action: {
                        store.send(.view(.editButtonTapped))
                    }, label: {
                        Image(systemName: "pencil")
                    })
                }
                .padding(.horizontal, 20)
                Text("parent: \(store.todoItem.parent?.title ?? "root")")
                    .foregroundStyle(.gray)
                if let subTodos = store.todoItem.items {
                    List(Array(subTodos), id: \.self) { todo in
                        Text("title: \(todo.title)")
                            .onTapGesture { _ in
                                store.send(.view(.totoCellTapped(todo)))
                            }
                    }
                }
            }
            .overlay(alignment: .bottom) {
                Button(action: {
                    store.send(.view(.showAddTodoButtonTapped))
                }, label: {
                    Text("SubTodo 추가")
                })
                .buttonStyle(.borderedProminent)
            }
            .sheet(isPresented: $store.isShowAddTodoSheet) {
                AddTodoView(store: store.scope(state: \.todo, action: \.todo))
            }
        }
    }
}

//#Preview {
//    TodoDetailView()
//}
