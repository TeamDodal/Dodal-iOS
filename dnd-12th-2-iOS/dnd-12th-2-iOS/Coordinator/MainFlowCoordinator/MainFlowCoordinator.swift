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
        case todoDetail(TodoDetailViewFeature)
    }
    
    @ObservableState
    struct State {
        /// 네비게이션 스택
        var path = StackState<Path.State>()
        
        /// HomeView store
        var homeViewStore = HomeViewFeature.State()
    }
    
    enum Action {
        /// 네비게이션 스택 액션
        case path(StackActionOf<Path>)
        
        /// HomeView action
        case homeViewStore(HomeViewFeature.Action)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.homeViewStore, action: \.homeViewStore) {
            HomeViewFeature()
        }
        Reduce { state, action in
            switch action {
                // MARK: - homeView action
            case let .homeViewStore(action):
                switch action {
                    // MARK: - View action
                case let .view(action):
                    switch action {
                    case let .todoCellTapped(todo):
                        state.path.append(.todoDetail(.init(todoItem: todo)))
                        return .none
                    default: return .none
                    }
                default: return .none
                }
                // MARK: - Navigation
            case let .path(action):
                switch action {
                    // todoDetail
                case let .element(id: id, action: .todoDetail(.destination(.popNavigationStack))):
                    state.path.pop(from: id)
                    return .none
                case let .element(id: _, action: .todoDetail(.view(.todoCellTapped(todo)))):
                    state.path.append(.todoDetail(.init(todoItem: todo)))
                    return .none
                default:
                    return .none
                }
            }
        }.forEach(\.path, action: \.path)
    }
}
