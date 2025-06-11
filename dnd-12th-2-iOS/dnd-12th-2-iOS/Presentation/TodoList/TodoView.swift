//
//  TodoView.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 5/6/25.
//

import SwiftUI

import ComposableArchitecture

struct TodoView: View {
    let store: StoreOf<TodoListFeature>
    
    init(store: StoreOf<TodoListFeature>) {
        self.store = store
    }
    
    var body: some View {
        WithPerceptionTracking {
            VStack(alignment: .leading, spacing: 0) {
                if store.todoItems.isEmpty {
                    VStack {
                        Image(.imgEmpty)
                            .resizable()
                            .frame(width: 261, height: 267)
                            .padding(.bottom, 16)
                        Text("모든 할 일을 완수했어요!")
                            .font(.pretendard(size: 24, weight: .bold))
                            .foregroundStyle(.gray900)
                            .padding(.bottom, 8)
                        Text("할 일을 추가해보세요. 스케줄을 관리하고\n설정하기 어려운 할 일을 만들어드립니다.")
                            .font(.pretendard(size: 14, weight: .medium))
                            .foregroundStyle(.gray600)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 127)
                    .padding(.bottom, 12)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(store.todoItems) { todo in
                                DDTodoCard(todo: todo) {

                                }.onTapGesture {
                                    store.send(.view(.todoCellTapped(todo)))
                                }
                            }
                        }
                        .padding(.top, 22)
                        .padding(.horizontal, 16)
                    }
                }
                Spacer()
            }
            .background(.gray50)
            .onAppear {
                store.send(.view(.viewonAppear))
            }
        }
    }
}
