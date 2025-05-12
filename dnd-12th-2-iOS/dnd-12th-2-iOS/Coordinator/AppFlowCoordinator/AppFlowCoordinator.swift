//
//  AppFlowCoordinator.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 5/6/25.
//

import ComposableArchitecture

@Reducer
struct AppFlowCoordinator {
    @ObservableState
    enum State {
        case mainTab(MainTabFeature.State)
        case onboarding
        
        init() {
            self = .mainTab(.init())
        }
    }
    
    enum Action {
        case mainTab(MainTabFeature.Action)
        case onboarding
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
        .ifCaseLet(\.mainTab, action: \.mainTab) {
            MainTabFeature()
        }
    }
}
