//
//  TodoSheetFeature.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 6/20/25.
//

import ComposableArchitecture
import Foundation

@Reducer
struct TodoSheetFeature {
    enum ViewState {
        case editTodo
        case setDueDate
    }
    @ObservableState
    struct State {
        /// 현재 보여질 화면
        var viewState: ViewState = .editTodo

        /// 마감일
        var dueDate: Date?
        
        var todoState = TodoEditorFeature.State()
        
        var calendarState = DueDateCalendarFeature.State()
        
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case todoAction(TodoEditorFeature.Action)
        case calendarAction(DueDateCalendarFeature.Action)
        case editingCanelled
        case crateTodoCompleted
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Scope(state: \.todoState, action: \.todoAction) {
            TodoEditorFeature()
        }
        Scope(state: \.calendarState, action: \.calendarAction) {
            DueDateCalendarFeature()
        }
        Reduce { state, action in
            switch action {
            case let .todoAction(action):
                switch action {
                case .deleteButtonTapped:
                    return .send(.editingCanelled)
                case .dismissSheet:
                    return .send(.crateTodoCompleted)
                case .dueDateButtonTapped:
                    state.viewState = .setDueDate
                    return .none
                default:
                    return .none
                }
            case let .calendarAction(action):
                switch action {
                case let .dueDateChanged(dueDate):
                    state.todoState.dueDate = dueDate
                    return .none
                case .backButtonTapped:
                    state.viewState = .editTodo
                    return .none
                default:
                    return .none
                }
            default:
                return .none
            }
        }
        ._printChanges()
    }
}
