//
//  TodoListFeature.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 5/10/25.
//

import ComposableArchitecture

@Reducer
struct TodoListFeature {
    @ObservableState
    struct State {
        var todoItems: [TodoItem] = []
    }
    
    enum Action: TCAAction {
        case view(ViewAction)
        case external(ExternalAction)
        case destination(DestinationAction)
        enum ViewAction {
            case viewonAppear
        }
        enum ExternalAction {}
        enum DestinationAction {}
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                // MARK: - ViewAction
            case let .view(viewAction):
                switch viewAction {
                case .viewonAppear:
                    return .none
                }
            default:
                return .none
            }
        }
    }
}
