//
//  TodoListViewFeature.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 7/23/25.
//

import ComposableArchitecture

@Reducer
struct TodoListViewFeature {
    @ObservableState
    struct State {
        var todoListStore = TodoListFeature.State()
        var todoSheetStore = TodoSheetFeature.State()
        var isShowTodoSheet = false
    }
    
    enum Action: ViewAction, TCAAction {
        case view(ViewAction)
        case external(ExternalAction)
        case destination(DestinationAction)
        
        enum ViewAction: BindableAction {
            case binding(BindingAction<State>)
            case sheetDismiss
            case sheetPresent
            case viewOnAppear
            case todoCellTapped(Todo)
            case setDueDateButtonTapped(Todo)
        }
        
        enum DestinationAction {}
        
        enum ExternalAction {}
        
        case todoSheetStore(TodoSheetFeature.Action)
        case todoListAction(TodoListFeature.Action)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer(action: \.view)
        Scope(state: \.todoSheetStore, action: \.todoSheetStore) {
            TodoSheetFeature()
        }
        Scope(state: \.todoListStore, action: \.todoListAction) {
            TodoListFeature()
        }
        Reduce { state, action in
            switch action {
            case .view(let action):
                switch action {
                case .viewOnAppear:
                    return .send(.todoListAction(.view(.viewonAppear)))
                case .sheetPresent:
                    state.isShowTodoSheet = true
                    return .none
                case .sheetDismiss:
                    guard let currentView = state.todoSheetStore.currentView else {
                        return .none
                    }
                    if currentView == .editTodo {
                        state.todoSheetStore.todoStore.isEditing = false
                    } else {
                        state.isShowTodoSheet = false
                        state.todoSheetStore = .init()
                    }
                    return .none
                case let .setDueDateButtonTapped(todoItem):
                    state.todoSheetStore = .setDueDate(todo: todoItem)
                    state.isShowTodoSheet = true
                    return .none
                default:
                    return .none
                }
            case let .todoSheetStore(action):
                switch action {
                case .editingCanelled, .crateTodoCompleted:
                    state.isShowTodoSheet = false
                    state.todoSheetStore = .init()
                    return .run { send in
                        try await Task.sleep(for: .seconds(0.3))
                        await send(.todoListAction(.view(.viewonAppear)))
                    }
                default:
                    return .none
                }
            default:
                return .none
            }
        }
    }
}
