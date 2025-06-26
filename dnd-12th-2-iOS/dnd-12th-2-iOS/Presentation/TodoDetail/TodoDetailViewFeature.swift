//
//  DetailFeature.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 5/28/25.
//

import Foundation

import ComposableArchitecture

@Reducer
struct TodoDetailViewFeature {
    @ObservableState
    struct State {
        var todoItem: Todo
        var isShowAddTodoSheet = false
        var isShowDeleteAlert = false
        var todoSheetState: TodoSheetFeature.State
        var todoList: TodoListFeature.State
        
        var isOverDepthLimit: Bool {
            todoItem.depth > 3
        }
        
        var dueDateButtonTitle: String {
            todoItem.dueDate?.toMonthDayString ?? "마감일"
        }
        
        init(todoItem: Todo) {
            self.todoItem = todoItem
            self.todoSheetState = .addSubTodo(parentId: todoItem.id)
            self.todoList = .init(parentID: todoItem.id)
        }
    }
    
    enum Action: ViewAction, TCAAction {
        case todoSheetAction(TodoSheetFeature.Action)
        case todoList(TodoListFeature.Action)
        
        // view에서 일어나는 액션을 정의합니다.
        case view(ViewAction)
        
        // 외부의존성과 일어나는 액션을 정의합니다.
        case external(ExternalAction)
        
        // 뷰이동 관련 액션
        case destination(DestinationAction)
        
        enum ViewAction: BindableAction {
            case binding(BindingAction<State>)
            case viewOnAppear
            case backButtonTapped
            case completeButtonTapped
            case createTodoButtonTapped
            case backgroundTapped
            case deleteButtonTapped
            case showDeleteAlert
            case showDeleteAlertDismissed
            case editButtonTapped
        }
        
        enum DestinationAction {
            case popNavigationStack
        }
        
        enum ExternalAction {
            case deleteTodoItem(id: UUID)            
            case completeTodoItem(Todo)
        }
    }
    
    @Dependency(\.todoClient) var todoClient
    
    var body: some Reducer<State, Action> {
        BindingReducer(action: \.view)
        Scope(state: \.todoSheetState, action: \.todoSheetAction) {
            TodoSheetFeature()
        }
        Scope(state: \.todoList, action: \.todoList) {
            TodoListFeature()
        }
        Reduce { state, action in
            switch action {
                // MARK: - View Action
            case let .view(viewAction):
                // MARK: - TodoDetailView action
                switch viewAction {
                case .viewOnAppear:
                    return .send(.todoList(.view(.viewonAppear)))
                case .backButtonTapped:
                    return .send(.destination(.popNavigationStack))
                case .completeButtonTapped:
                    state.todoItem.isCompleted = true
                    return .send(.external(.completeTodoItem(state.todoItem)))
                case .createTodoButtonTapped:
                    state.todoSheetState = .init(parentId: state.todoItem.id)
                    state.isShowAddTodoSheet = true
                    return .none
                case .backgroundTapped:
                    guard let currentView = state.todoSheetState.currentView else {
                        return .none
                    }
                    if currentView == .editTodo {
                        state.todoSheetState.todoState.isEditing = false
                    } else {
                        state.todoSheetState = .init()
                        state.isShowAddTodoSheet = false
                    }
                    return .none
                case .showDeleteAlert:
                    state.isShowDeleteAlert = true
                    return .none
                case .deleteButtonTapped:
                    return .send(.external(.deleteTodoItem(id: state.todoItem.id)))
                case .showDeleteAlertDismissed:
                    state.isShowDeleteAlert = false
                    return .none
                case .editButtonTapped:
                    state.todoSheetState = .editTodo(todo: state.todoItem)
                    state.isShowAddTodoSheet = true
                    return .none
                default:
                    return .none
                }
                // MARK: - CreateTodo action
            case let .todoSheetAction(action):
                switch action {
                case .editingCanelled, .crateTodoCompleted:
                    state.isShowAddTodoSheet = false
                    state.todoSheetState = .init(parentId: state.todoItem.id)
                    return .send(.todoList(.view(.viewonAppear)))
                case let .todoAction(.editTodoCompleted(updatedTodo)):
                    state.todoItem = updatedTodo
                    return .none
                default:
                    return .none
                }
                // MARK: - external
            case let .external(externalAction):
                switch externalAction {
                case let .deleteTodoItem(id):
                    return .run { send in
                        try todoClient.deleteTodoItem(id)
                        await send(.destination(.popNavigationStack))
                    }
                case let .completeTodoItem(todoItem):
                    return .run { send in
                        try todoClient.editTodoItem(todoItem)
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
