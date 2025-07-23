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
        var todoListStore = TodoListViewFeature.State()                
        var path = StackState<Path.State>()
    }
    
    enum Action {
        case todoListStore(TodoListViewFeature.Action)
        case path(StackActionOf<Path>)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.todoListStore, action: \.todoListStore) {
            TodoListViewFeature()
        }
        
        Reduce { state, action in
            switch action {
                // MARK: - Todolist action
            case let .todoListStore(.view(.todoCellTapped(todo))):
                state.path.append(.todoDetail(.init(todoItem: todo)))
                return .none
                // MARK: - Navigation action
            case let .path(action):
                switch action {
                case let .element(id: id, action: .todoDetail(.destination(.popNavigationStack))):
                    state.path.pop(from: id)
                    return .none
                case let .element(id: _, action: .todoDetail(.view(.todoCellTapped(todo)))):
                    state.path.append(.todoDetail(.init(todoItem: todo)))
                    return .none
                default:
                    return .none
                }
                
            default:
                return .none
            }
        }.forEach(\.path, action: \.path)
    }
}
