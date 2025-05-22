//
//  MainViewFeature.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 5/10/25.
//

import ComposableArchitecture

@Reducer
struct MainViewFeature {
    @ObservableState
    struct State {
        var isShowAddTodoSheet = false
        var todo = TodoFeature.State(isEdit: false)
        var todoList = TodoListFeature.State()
    }
    
    enum Action: ViewAction, TCAAction {
        // view에서 일어나는 액션을 정의합니다.
        case view(ViewAction)
        
        // 외부의존성과 일어나는 액션을 정의합니다.
        case external(ExternalAction)
        
        // 뷰이동 관련 액션
        case destination(DestinationAction)
        
        case todo(TodoFeature.Action)
        case todoList(TodoListFeature.Action)
        
        enum ViewAction: BindableAction {
            case binding(BindingAction<State>)
            case showAddTodoButtonTapped
        }
        
        enum DestinationAction {
            case goToTodoDetail(TodoItem)
        }
        
        enum ExternalAction {}
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer(action: \.view)
        Scope(state: \.todo, action: \.todo) {
            TodoFeature()
        }
        Scope(state: \.todoList, action: \.todoList) {
            TodoListFeature()
        }
        Reduce { state, action in
            switch action {
                // MARK: - View
            case let .view(viewAction):
                switch viewAction {
                case .binding:
                    return .none
                case .showAddTodoButtonTapped:
                    state.isShowAddTodoSheet = true
                    return .none
                }
                // MARK: - TodoView
            case let .todo(todoAction):
                switch todoAction {
                case .view(.addTodoComplete):
                    state.isShowAddTodoSheet = false
                    return .send(.todoList(.view(.viewonAppear)))
                default:
                    return .none
                }
                // MARK: - TodoListView
            case let .todoList(todoListAction):
                switch todoListAction {
                case let .view(.todoCellTapped(todo)):
                    return .none
//                    return .send(.destination(.goToTodoDetail(todo)))
                default:
                    return .none
                }
            default:
                return .none
            }
        }
    }
}
