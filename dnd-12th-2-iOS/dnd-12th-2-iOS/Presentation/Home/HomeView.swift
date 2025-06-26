//
//  HomeView.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 6/18/25.
//

import SwiftUI
import ComposableArchitecture
struct HomeView: View {
    @Perception.Bindable var store: StoreOf<HomeViewFeature>
    
    var body: some View {
        WithPerceptionTracking {
            VStack {
                DDHeader(dateText: "5월 12일 (월)") {
                    
                }
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {
                        if store.isShowDdayPopup, !store.dDayTodos.isEmpty {
                            DDTodoCardList(
                                todos: store.dDayTodos,
                                title: "마감일까지 D-1",
                                todoCellTapped: { todo in
                                    store.send(.view(.todoCellTapped(todo)))
                                },
                                dueDateButtonTapped: { todo in
                                    store.send(.view(.todoCellTapped(todo)))
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
                                store.send(.view(.setDueDateButtonTapped(todo)))
                            }
                        )
                        
                        DDTodoCardList(
                            todos: store.recentTodos,
                            title: "최근",
                            itemsPerPage: 5,
                            todoCellTapped: { todo in
                                store.send(.view(.todoCellTapped(todo)))
                            },
                            dueDateButtonTapped: { todo in
                                store.send(.view(.setDueDateButtonTapped(todo)))
                            }
                        )
                    }
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                }
                .overlay(alignment: .bottom, content: {
                    DDAddTaskButton {
                        store.send(.view(.sheetPresent))
                    }
                })
            }
            .background(.gray50)
        }
        .bottomSheet(isPresented: $store.isShowTodoSheet, content: {
            TodoSheetView(store: store.scope(state: \.todoSheetStore, action: \.todoSheetStore))
                .fixedSize(horizontal: false, vertical: true)
        }, onDismiss: {
            store.send(.view(.sheetDismiss))
        })
        .onAppear {
            store.send(.view(.viewOnAppear))
        }
    }
}

//#Preview {
//    HomeView()
//}
