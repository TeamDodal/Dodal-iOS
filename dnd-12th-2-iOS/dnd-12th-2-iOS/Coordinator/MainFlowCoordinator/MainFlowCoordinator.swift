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
        case todoDetail(TodoDetailFeature)
    }
    
    @ObservableState
    struct State {
        var path = StackState<Path.State>()
        var root = MainViewFeature.State()
    }
    
    enum Action {
        case path(StackActionOf<Path>)
        case root(MainViewFeature.Action)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.root, action: \.root) {
            MainViewFeature()
        }
        Reduce { state, action in
            switch action {
            case let .path(action):
                switch action {
                case let .element(id: id, action: .todoDetail(.destination(.popNavigationStack))):
                    state.path.pop(from: id)
                    return .none
                case let .element(id: _, action: .todoDetail(.view(.totoCellTapped(todo)))):
                    state.path.append(.todoDetail(.init(todoItem: todo)))
                    return .none
                default:
                    return .none
                }
            case let .root(.destination(.goToTodoDetail(todo))):
                state.path.append(.todoDetail(.init(todoItem: todo)))
                return .none
            default:
                return .none
            }
        }.forEach(\.path, action: \.path)
    }
}
