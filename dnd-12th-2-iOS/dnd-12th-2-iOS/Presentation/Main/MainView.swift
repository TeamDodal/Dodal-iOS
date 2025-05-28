//
//  MainView.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 5/6/25.
//

import SwiftUI

import ComposableArchitecture

struct MainView: View {
    @Perception.Bindable fileprivate var store: StoreOf<MainViewFeature>
    
    init(store: StoreOf<MainViewFeature>) {
        self.store = store
    }
    
    var body: some View {
        WithPerceptionTracking {
            DDHeader(dateText: "5월 12일 (월)") {
                
            }
            TodoListView(store: store.scope(state: \.todoList, action: \.todoList))
                .overlay(alignment: .bottom, content: {
                    VStack {
                        Spacer()
                        Button(action: {
                            store.send(.view(.showAddTodoButtonTapped))
                        }, label: {
                            Text("Todo create")
                        })
                        .buttonStyle(.borderedProminent)
                    }
                })
                .sheet(isPresented: $store.isShowAddTodoSheet ) {
                    AddTodoView(store: store.scope(state: \.todo, action: \.todo))
                }
        }
        .background(.gray50)
    }
}

#Preview {
    MainView(store: .init(initialState: MainViewFeature.State(), reducer: {
        MainViewFeature()
    }))
}
