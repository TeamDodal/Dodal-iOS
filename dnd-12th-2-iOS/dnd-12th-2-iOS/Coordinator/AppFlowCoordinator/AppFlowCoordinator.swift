//
//  AppFlowCoordinator.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 5/6/25.
//

import ComposableArchitecture

@Reducer
struct AppFlowCoordinator {
    
    enum State {
        case mainTab
        case onboarding
        
        init() {
            self = .onboarding
        }
    }
    
    enum Action {
        case mainTab
        case onboarding
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
    }
}
