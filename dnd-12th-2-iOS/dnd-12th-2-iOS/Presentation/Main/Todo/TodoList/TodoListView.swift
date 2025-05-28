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
    
    @State var isShowDdayView = true
    
    var body: some View {
        WithPerceptionTracking {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    if isShowDdayView {
                        DDTodoCardList(todos: store.todoItems, title:"마감일까지 d-1") { todo in
                            
                        } cancelAction: {
                            withAnimation(.default) {
                                isShowDdayView = false
                            }
                        }
                        .shadow(color: .mainBlue.opacity(0.25), radius: 12, x: 0, y: 0)
                    }
                    DDTodoCardList(todos: store.todoItems, title:"이번주") { todo in
                        
                    }
                    DDTodoCardList(todos: store.todoItems, title:"최근") { todo in
                        
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
