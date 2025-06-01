//
//  TodoDetail.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 5/27/25.
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
                            
                        }
                        .padding(.trailing, 12)
                        Button(action: {
                            
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
                            DDTodoRow(todo: todo) {
                                
                            } onTap: {
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
        }
    }
}

//#Preview {
//    TodoDetail(todos: [Todo(
//        id: UUID(),
//        title: "운동하기",
//        content: "헬스장 가기",
//        dueDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
//        children: [
//            Todo(
//                id: UUID(),
//                title: "스트레칭",
//                content: nil,
//                dueDate: Date(),
//                parentID: nil,
//                depth: 1,
//                path: "운동하기 > 스트레칭"
//            ),
//            Todo(
//                id: UUID(),
//                title: "웨이트 트레이닝",
//                content: nil,
//                dueDate: nil,
//                parentID: nil,
//                depth: 1,
//                path: "운동하기 > 웨이트 트레이닝"
//            )
//        ],
//        parentID: nil,
//        depth: 0,
//        path: "운동하기"
//    ),
//                       Todo(
//                        id: UUID(),
//                        title: "책 읽기",
//                        content: "자기계발서 30분",
//                        dueDate: nil,
//                        children: [],
//                        parentID: nil,
//                        depth: 0,
//                        path: "책 읽기"
//                       )
//    ])
//}
