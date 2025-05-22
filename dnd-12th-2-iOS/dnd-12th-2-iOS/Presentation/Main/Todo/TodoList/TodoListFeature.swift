//
//  TodoListFeature.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 5/10/25.
//

import Foundation

import ComposableArchitecture

@Reducer
struct TodoListFeature {
    @ObservableState
    struct State {
        var todoItems: [Todo] = []
    }
    
    enum Action: TCAAction {
        case view(ViewAction)
        case external(ExternalAction)
        case destination(DestinationAction)
        
        enum ViewAction {
            case viewonAppear
            case responseTodoItem([Todo])
            case todoCellTapped(UUID)
        }
        
        enum ExternalAction {
            case fetchTodoItem
        }
        
        enum DestinationAction {}
    }
    
    @Dependency(\.todoClient) var todoClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                // MARK: - view
            case let .view(viewAction):
                switch viewAction {
                case .viewonAppear:
                    return .run { send in
                        await send(.external(.fetchTodoItem))
                    }
                case let .responseTodoItem(todoItem):
                    state.todoItems = todoItem
                    return .none
                default:
                    return .none
                }
                // MARK: - external
            case let .external(externalAction):
                switch externalAction {
                case .fetchTodoItem:
                    return .run { send in
                        let todos = try todoClient.fetchTodoItems()
                        await send(.view(.responseTodoItem(todos)))
                    }
                }
            default:
                return .none
            }
        }
    }
}
