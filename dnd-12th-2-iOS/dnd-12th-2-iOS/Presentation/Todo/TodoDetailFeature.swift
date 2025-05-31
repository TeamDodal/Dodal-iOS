//
//  DetailFeature.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 5/28/25.
//

import Foundation

import ComposableArchitecture

@Reducer
struct TodoDetailFeature {
    @ObservableState
    struct State {
        var todoItem: Todo
        var isShowAddTodoSheet = false
        var todo: TodoFeature.State
        
        var isOverDepthLimit: Bool {
            todoItem.depth > 3
        }
        
        init(todoItem: Todo) {
            self.todoItem = todoItem
            self.todo = TodoFeature.State(parentId: todoItem.id, isEdit: false)
        }
    }
    
    enum Action: ViewAction, TCAAction {
        case todo(TodoFeature.Action)
        
        // view에서 일어나는 액션을 정의합니다.
        case view(ViewAction)
        
        // 외부의존성과 일어나는 액션을 정의합니다.
        case external(ExternalAction)
        
        // 뷰이동 관련 액션
        case destination(DestinationAction)
        
        enum ViewAction: BindableAction {
            case binding(BindingAction<State>)
            case showAddTodoButtonTapped
            case todoCellTapped(Todo)
            case editButtonTapped
            case deleteButtonTapped
        }
        
        enum DestinationAction {
            case popNavigationStack
        }
        
        enum ExternalAction {
            case deleteTodoItem(id: UUID)
        }
    }
    
    @Dependency(\.todoClient) var todoClient
    
    var body: some Reducer<State, Action> {
        Scope(state: \.todo, action: \.todo) {
            TodoFeature()
        }
        BindingReducer(action: \.view)
        Reduce { state, action in
            switch action {
                // MARK: - View Action
            case let .view(viewAction):
                switch viewAction {
                case .showAddTodoButtonTapped:
                    state.todo = .init(parentId: state.todoItem.id, isEdit: false)
                    state.isShowAddTodoSheet = true
                    return .none
                case .editButtonTapped:
                    state.todo = TodoFeature.State(parentId: state.todoItem.id, title: state.todoItem.title, isEdit: true)
                    state.isShowAddTodoSheet = true
                    return .none
                case .deleteButtonTapped:
                    return .send(.external(.deleteTodoItem(id: state.todoItem.id)))
                default: return .none
                }
                // MARK: - Todo
            case .todo(.view(.addTodoComplete)):
                state.isShowAddTodoSheet = false
                return .none
                // MARK: - external
            case let .external(externalAction):
                switch externalAction {
                case let .deleteTodoItem(id):
                    return .run { send in
                        try todoClient.deleteTodoItem(id)
                        await send(.destination(.popNavigationStack))
                    }
                }
            case let .destination(destination):
                switch destination {
                case .popNavigationStack:
                    return .none
                }
            default: return .none
            }
        }
    }
}
