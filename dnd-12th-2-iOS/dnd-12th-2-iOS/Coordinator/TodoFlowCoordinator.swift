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
        case todoDetail(TodoDetailFeature)
    }

    @ObservableState
    struct State {
        var root = TodoTabFeature.State()
        var path = StackState<Path.State>()
    }

    enum Action {
        case root(TodoTabFeature.Action)
        case path(StackActionOf<Path>)
    }

    var body: some Reducer<State, Action> {
        Scope(state: \.root, action: \.root) {
            TodoTabFeature()
        }

        Reduce { state, action in
            switch action {
            case let .root(.view(.todoRowTapped(todo))):
                state.path.append(.todoDetail(.init(todoItem: todo)))
                return .none

            case let .path(.element(id: id, action: .todoDetail(.destination(.popNavigationStack)))):
                state.path.pop(from: id)
                return .none

            default:
                return .none
            }
        }.forEach(\.path, action: \.path)
    }
}
