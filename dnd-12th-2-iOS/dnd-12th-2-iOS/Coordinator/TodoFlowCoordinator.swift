//
//  TodoFlowCoordinator.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 5/30/25.
//

import ComposableArchitecture

@Reducer
struct TodoFlowCoordinator {
    @Reducer
    enum Path {
        case todoDetail(TodoDetailViewFeature)
    }

    @ObservableState
    struct State {
        var root = TodoListFeature.State()
        var path = StackState<Path.State>()
    }

    enum Action {
        case root(TodoListFeature.Action)
        case path(StackActionOf<Path>)
    }

    var body: some Reducer<State, Action> {
        Scope(state: \.root, action: \.root) {
            TodoListFeature()
        }

        Reduce { state, action in
            switch action {
            case let .root(.view(.todoCellTapped(todo))):
                state.path.append(.todoDetail(.init(todoItem: todo)))
                return .none                        
            default:
                return .none
            }
        }.forEach(\.path, action: \.path)
    }
}
