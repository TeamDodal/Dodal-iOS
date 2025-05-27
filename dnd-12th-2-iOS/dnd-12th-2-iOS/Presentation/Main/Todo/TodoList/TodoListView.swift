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
            VStack(alignment: .leading, spacing: 0) {
                DDHeader(dateText: dateString) {
                    
                }
                ScrollView {
                    LazyVStack(spacing: 12) {
                        DDTodoCard(title:"마감일까지 d-1", todos: store.todoItems)
                            .background(.gray0)
                            .cornerRadius(12)
                    
                    }
                    .padding(.top, 8)
                    .padding(.horizontal, 16)
                }
                Spacer()
            }
            .background(.gray50)
            .onAppear {
                store.send(.view(.viewonAppear))
            }
        }
    }
    
    private var dateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일"
        let date = formatter.string(from: Date())
        formatter.dateFormat = "E"
        let day = formatter.string(from: Date())
        
        return "\(date) (\(day))"
    }
}

//#Preview {
//    TodoListView(store: .init(initialState: TodoList, reducer: <#T##() -> Reducer#>))
//}
