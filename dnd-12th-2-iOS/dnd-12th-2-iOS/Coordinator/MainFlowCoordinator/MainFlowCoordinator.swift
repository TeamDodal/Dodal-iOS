//
//  MainFlowCoordinator.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 5/6/25.
//

import ComposableArchitecture

@Reducer
struct MainFlowCoordinator {
    @Reducer
    enum Path {
        case todoDetail
    }
    
    @ObservableState
    struct State {
        var path = StackState<Path.State>()   
    }
    
    enum Action {
        case path(StackActionOf<Path>)
    }
    
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .path(action):
                switch action {
                default:
                    return .none
                }
            }
        }.forEach(\.path, action: \.path)
    }
}
