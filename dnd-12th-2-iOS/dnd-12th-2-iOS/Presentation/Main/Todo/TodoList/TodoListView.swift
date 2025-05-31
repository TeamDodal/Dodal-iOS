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
            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    if store.isShowDdayPopup {
                        DDTodoCardList(
                            todos: store.dDayTodos,
                            title: "마감일까지 D-1",
                            todoCellTapped: { todo in
                                store.send(.view(.todoCellTapped(todo)))
                            },
                            dueDateButtonTapped: { todo in
                              
                            },
                            deleteButtonTapped: {
                                store.send(.view(.dismissDdayPopup), animation: .easeInOut)
                            }
                        )
                        .shadow(color: .mainBlue.opacity(0.25), radius: 12, x: 0, y: 0)
                    }
                    
                    DDTodoCardList(
                        todos: store.thisWeekTodos,
                        title: "이번주",
                        todoCellTapped: { todo in
                            store.send(.view(.todoCellTapped(todo)))
                        },
                        dueDateButtonTapped: { todo in
                            
                        }
                    )
                    
                    DDTodoCardList(
                        todos: store.recentTodos,
                        title: "최근",
                        todoCellTapped: { todo in
                            store.send(.view(.todoCellTapped(todo)))
                        },
                        dueDateButtonTapped: { todo in
                            
                        }
                    )
                }
                
                .padding(.top, 16)
                .padding(.horizontal, 16)
                
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
