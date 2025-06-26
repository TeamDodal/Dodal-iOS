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
        
        var title: String {
            switch self {
            case .editTodo:
                ""
            case .setDueDate:
                "마감일"
            }
        }
    }
    @ObservableState
    struct State {
        /// 화면 스택
        var viewStack: [ViewState] = []
        
        /// 현재 보여질 화면
        var currentView: ViewState? {
            viewStack.last
        }
        
        var todoState: TodoEditorFeature.State
        
        var calendarState: DueDateCalendarFeature.State
        
        var isRootView: Bool {
            viewStack.count <= 1
        }
        
        /// todo 수정
        init(viewStack: [ViewState] = [.editTodo], todo: Todo, isEdit: Bool = false) {
            self.viewStack = viewStack
            self.todoState = .init(isEdit: isEdit, id: todo.id, title: todo.title, content: todo.content ?? "", dueDate: todo.dueDate)
            self.calendarState = .init(todoItem: todo)
        }
        
        ///  todo 생성
        init() {
            self.viewStack = [.editTodo]
            self.todoState = .init()
            self.calendarState = .init()
        }
        
        init(parentId: UUID) {
            self.viewStack = [.editTodo]
            self.todoState = .init(parentId: parentId)
            self.calendarState = .init()
        }
        
        static func setDueDate(todo: Todo) -> State {
            .init(viewStack: [.setDueDate], todo: todo)
        }
        
        static func addTodo() -> State {
            .init()
        }
        
        static func addSubTodo(parentId: UUID) -> State {
            .init(parentId: parentId)
        }
        
        static func editTodo(todo: Todo) -> State {
            .init(viewStack: [.editTodo], todo: todo, isEdit: true)
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case todoAction(TodoEditorFeature.Action)
        case calendarAction(DueDateCalendarFeature.Action)
        case editingCanelled
        case crateTodoCompleted
        case backButtonTapped
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
            case .backButtonTapped:
                if !state.isRootView {
                    state.viewStack.removeLast()
                }
                return .none
            case let .todoAction(action):
                switch action {
                case .deleteButtonTapped:
                    return .send(.editingCanelled)
                case .dismissSheet:
                    return .send(.crateTodoCompleted)
                case .dueDateButtonTapped:
                    state.viewStack.append(.setDueDate)
                    return .none
                default:
                    return .none
                }
            case let .calendarAction(action):
                switch action {
                case let .dueDateChanged(dueDate):
                    state.todoState.dueDate = dueDate
                    return .none
                case let .setDueDateCompleted(updatedTodo):
                    if state.isRootView {
                        return .concatenate([
                            .send(.todoAction(.editTodo(updatedTodo))),
                            .send(.editingCanelled)
                        ])
                    } else {
                        state.viewStack.removeLast()
                        return .none
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
