//
//  TodoDetailFeature.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 5/12/25.
//

import Foundation

import ComposableArchitecture

@Reducer
struct TodoDetailFeature {
    @ObservableState
    struct State {
        var todo: TodoItem
        var isShowAddTodoSheet = false
        
        init(todo: TodoItem) {
            self.todo = todo
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case showAddTodoButtonTapped
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .showAddTodoButtonTapped:
                state.isShowAddTodoSheet = true
                return .none
            default:
                return .none
            }
        }
    }
}
