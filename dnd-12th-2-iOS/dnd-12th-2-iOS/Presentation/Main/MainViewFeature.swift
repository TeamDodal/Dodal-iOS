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
        var todoTap = TodoTabFeature.State()
    }
    
    enum Action: ViewAction, TCAAction {
        // TCAAction
        case view(ViewAction)
        case external(ExternalAction)
        case destination(DestinationAction)
        
        // SubFeature
        case todo(TodoFeature.Action)
        case todoList(TodoListFeature.Action)
        case todoTap(TodoTabFeature.Action)
        
        enum ViewAction: BindableAction {
            case binding(BindingAction<State>)
            case showAddTodoButtonTapped
        }
        
        enum DestinationAction {
            case goToTodoDetail(Todo)
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
        Scope(state: \.todoTap, action: \.todoTap) {
            TodoTabFeature()
        }
        Reduce { state, action in
            switch action {
            case .view(.binding(\.isShowAddTodoSheet)):
                state.todo = .init(isEdit: false)
                return .none
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
                
                // MARK: - TodoTap
            case let .todoTap(todoTapAction):
                switch todoTapAction {
                case let .view(.todoRowTapped(todo)):
                    return .send(.destination(.goToTodoDetail(todo)))
                default:
                    return .none
                }
            default:
                return .none
            }
        }
    }
}
