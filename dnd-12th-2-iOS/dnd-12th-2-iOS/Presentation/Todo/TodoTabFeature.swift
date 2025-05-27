//
//  TodoTabFeature.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 5/27/25.
//

import Foundation

import ComposableArchitecture

@Reducer
struct TodoTabFeature {
    
    @ObservableState
    struct State: Equatable {
        var todoItems: [Todo] = []
    }

    enum Action: TCAAction {
        case view(ViewAction)
        case external(ExternalAction)
        case destination(DestinationAction)

        enum ViewAction: Equatable {
            case viewonAppear
            case responseTodoItem([Todo])
            case dueDateButtonTapped(UUID)
        }

        enum ExternalAction: Equatable {
            case fetchTodoItems
        }

        enum DestinationAction: Equatable {}
    }

    @Dependency(\.todoClient) var todoClient

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                
            case let .view(viewAction):
                switch viewAction {
                case .viewonAppear:
                    return .run { send in
                        await send(.external(.fetchTodoItems))
                    }

                case let .responseTodoItem(todoList):
                    state.todoItems = todoList
                    return .none

                case let .dueDateButtonTapped(id):
                    // 마감일 설정
                    return .none
                }

            case let .external(externalAction):
                switch externalAction {
                case .fetchTodoItems:
                    return .run { send in
                        let todos = try todoClient.fetchTodoItems()
                        await send(.view(.responseTodoItem(todos)))
                    }
                }

            case .destination:
                return .none
            }
        }
    }
}
