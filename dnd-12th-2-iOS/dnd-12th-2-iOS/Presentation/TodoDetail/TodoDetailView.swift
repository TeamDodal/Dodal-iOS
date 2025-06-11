//
//  TodoDetail.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 5/27/25.
//

import SwiftUI

import ComposableArchitecture

struct TodoDetailView: View {
    @Perception.Bindable private var store: StoreOf<TodoDetailViewFeature>
    
    init(store: StoreOf<TodoDetailViewFeature>) {
        self.store = store
    }
    
    var body: some View {
        WithPerceptionTracking {
            VStack {
                VStack {
                    HStack {
                        Button(action: {
                            store.send(.destination(.popNavigationStack))
                        }) {
                            Image(.iconBack)
                                .foregroundStyle(.gray900)
                        }
                        Spacer()
                        DDImageButton(type: .complete, text: nil) {
                            store.send(.view(.setCompleteButtonTapped))
                        }                        
                        .padding(.trailing, 12)
                        Button(action: {
                            store.send(.view(.showDeleteAlert))
                        }) {
                            Image(.iconEdit)
                                .foregroundStyle(.gray900)
                        }
                    }
                    .padding(12)
                    
                    HStack {
                        Image(.iconFolder)
                            .resizable()
                            .frame(width: 16, height: 16)
                        
                        ForEach(store.todoItem.path, id: \.self) { pathName in
                            Button(action: {
                                
                            }) {
                                Text(pathName)
                                    .font(.pretendard(size: 12, weight: .medium))
                                    .lineLimit(1)
                                    .foregroundStyle(.gray500)
                            }
                            Image(.iconForward)
                                .resizable()
                                .frame(width: 12, height: 12)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 12)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(store.todoItem.title)
                                .font(.pretendard(size: 22, weight: .semibold))
                                .foregroundStyle(.gray900)
                            Spacer()
                            Button(action: {
                                store.send(.view(.editButtonTapped))
                            }) {
                                Image(.iconPencil)
                            }
                        }
                        Text(store.todoItem.content ?? "")
                            .font(.pretendard(size: 14, weight: .regular))
                            .foregroundStyle(.gray700)
                    }
                    .padding(.horizontal, 16)
                    
                    HStack {
                        DDImageButton(type: .dueDate, text: nil) {
                            store.send(.view(.setDueDateButtonTapped(store.todoItem)))
                        }
                        Spacer()
                    }
                    .padding(.leading, 16)
                    .padding(.bottom, 16)
                    .padding(.top, 12)
                }
                .background(.gray0)
                
                ScrollView {
                   LazyVStack(spacing: 8) {
                       ForEach(store.todoList.todoItems) { todo in
                           DDTodoCard(todo: todo) {
                               store.send(.view(.setDueDateButtonTapped(todo)))
                           }.onTapGesture {
                               store.send(.view(.todoCellTapped(todo)))
                           }
                        }
                    }
                    .padding(.top, 30)
                    .padding(.horizontal, 16)
                }
            }
            .background(.gray50)
            .toolbar(.hidden, for: .navigationBar)
            .overlay(alignment: .bottom) {
                DDAddTaskButton(action: {
                    store.send(.view(.showAddTodoButtonTapped))
                })
            }
            .bottomSheet(isPresented: $store.isShowAddTodoSheet, content: {
                TodoModalView(store: store.scope(state: \.todo, action: \.todo))
                    .fixedSize(horizontal: false, vertical: true)
            })
            .onAppear {
                store.send(.view(.viewOnAppear))
            }
            .overlay(alignment: .center, content: {
                if store.state.isShowDeleteAlert {
                    DDAlert(
                        title: "할 일을 정말 삭제할까요?",
                        cancelButtonTitle: "취소",
                        confirmButtonTitle: "삭제",
                        onCancel: {
                            store.send(.view(.showDeleteAlertDismissed))
                        },
                        onConfirm: {
                            store.send(.external(.deleteTodoItem(id: store.todoItem.id)))
                        }
                    )
                }
            })
        }
    }
}
