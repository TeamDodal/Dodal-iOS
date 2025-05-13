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
    
    enum Action: ViewAction, TCAAction {
        
        // view에서 일어나는 액션을 정의합니다.
        case view(ViewAction)
        
        // 외부의존성과 일어나는 액션을 정의합니다.
        case external(ExternalAction)
        
        // 뷰이동 관련 액션
        case destination(DestinationAction)
        
        enum ViewAction: BindableAction {
            case binding(BindingAction<State>)
            case showAddTodoButtonTapped
            case totoCellTapped(TodoItem)
        }
        
        enum DestinationAction {}
        
        enum ExternalAction {}
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer(action: \.view)
        Reduce { state, action in
            switch action {
                // MARK: - View Action
            case let .view(viewAction):
                switch viewAction {
                case .showAddTodoButtonTapped:
                    state.isShowAddTodoSheet = true
                    return .none
                default:
                    return .none
                }
            default:
                return .none
            }
        }
    }
}
