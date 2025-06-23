//
//  MainFlowCoordinatorView.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 5/6/25.
//

import SwiftUI

import ComposableArchitecture

struct MainFlowCoordinatorView: View {
    @Perception.Bindable var store: StoreOf<MainFlowCoordinator>
    
    var body: some View {
        WithPerceptionTracking {
            NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
                HomeView(store: store.scope(state: \.homeViewState, action: \.homeViewAction))
            } destination: { store in
                switch store.case {
                case let .todoDetail(store):
                    TodoDetailView(store: store)
                }
            }
        }
    }
}

#Preview {
    MainFlowCoordinatorView(store: .init(initialState: MainFlowCoordinator.State(), reducer: {
        MainFlowCoordinator()
    }))
}
