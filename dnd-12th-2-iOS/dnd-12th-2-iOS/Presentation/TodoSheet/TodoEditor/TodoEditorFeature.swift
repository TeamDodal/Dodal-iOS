//
//  TodoFeature.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 6/24/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct TodoEditorFeature {
    @ObservableState
    struct State {
        var parentId: UUID?
        /// todoId
        var id: UUID?
        
        /// 할일 제목
        var title: String = ""
        
        /// 할일 상세 설명
        var content: String = ""
        
        /// 마감일
        var dueDate: Date?
        
        /// 편집중인 상태 여부
        var isEditing = true
        
        var dueDateButtonTitle: String {
            dueDate?.toMonthDayString ?? "마감일"
        }
        
        var isSubmitButtonEnabled: Bool {
            !title.isEmpty
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case editingChanged(Bool)
        case deleteButtonTapped
        case dismissSheet
        case dueDateButtonTapped
        case createButtonTapped
        case crateTodo(Todo)
        case createSubTodo(parentId: UUID, todoItem: Todo)
        case editTodo(Todo)
    }
    
    @Dependency(\.todoClient) var todoClient
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .editingChanged(isEditing):
                state.isEditing = isEditing
                return .none
            case .createButtonTapped:
                let todo = Todo(title: state.title, content: state.content, dueDate: state.dueDate)
                if let parentId = state.parentId {
                    return .concatenate([
                        .send(.createSubTodo(parentId: parentId, todoItem: todo)),
                        .send(.dismissSheet)
                    ])
                } else {
                    return .concatenate([
                        .send(.crateTodo(todo)),
                        .send(.dismissSheet)
                    ])
                }
            case let .crateTodo(todo):
                return .run { send in                    
                    todoClient.createTodoItem(todo)
                }
            case let .editTodo(todo):
                return .run { send in
                    try todoClient.editTodoItem(todo)
                }
            case let .createSubTodo(parentId, todoItem):
                return .run { send in
                    try todoClient.createSubTodoItem(parentId, todoItem)
                }
            default:
                return .none
            }
        }
    }
}

