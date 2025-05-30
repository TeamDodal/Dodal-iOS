//
//  TodoFlowCoordinatorView.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 5/30/25.
//

import SwiftUI

import ComposableArchitecture

struct TodoFlowCoordinatorView: View {
    @Perception.Bindable var store: StoreOf<TodoFlowCoordinator>
    
    var body: some View {
        WithPerceptionTracking {
            NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
                TodoView(store: store.scope(state: \.root, action: \.root))
            } destination: { store in
                switch store.case {
                case let .todoDetail(store):
                    TodoDetail(store: store)
                }
            }
        }
    }
}

#Preview {
    TodoFlowCoordinatorView(store: .init(initialState: TodoFlowCoordinator.State(), reducer: {
        TodoFlowCoordinator()
    }))
}
