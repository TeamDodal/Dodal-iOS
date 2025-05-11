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
            VStack {
                Spacer()
                Button(action: {
                    store.send(.view(.showAddTodoButtonTapped))
                }, label: {
                    Text("Todo create")
                })
                .buttonStyle(.borderedProminent)
            }
            .sheet(isPresented: $store.isShowAddTodoSheet ) {
                AddTodoView(store: store.scope(state: \.todo, action: \.todo))
            }
        }
    }
}

#Preview {
    MainView(store: .init(initialState: MainViewFeature.State(), reducer: {
        MainViewFeature()
    }))
}
