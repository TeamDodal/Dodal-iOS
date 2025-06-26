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
        /// 수정중인 상태를 나타냄
        var isEdit: Bool = false
        /// 상위 todo의 id
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
        /// 하단의 마감일 설정 버튼
        var dueDateButtonTitle: String {
            dueDate?.toMonthDayString ?? "마감일"
        }
        /// 생성하기 버튼 활성화 여부
        var isSubmitButtonEnabled: Bool {
            !title.isEmpty
        }
    }
    
    enum Action: BindableAction {
        /// 동적으로 바인딩 하기위한 액션
        case binding(BindingAction<State>)
        /// 편집상태 변경 알림
        case editingChanged(Bool)
        /// 삭제 버튼 탭
        case deleteButtonTapped
        /// sheet 제거
        case dismissSheet
        /// 마감일 설정 버튼 탭
        case dueDateButtonTapped
        /// 생성하기 버튼 탭
        case createButtonTapped
        /// 수정하기 버튼 탭
        case editButtonTapped
        /// todo 추가
        case crateTodo(Todo)
        /// parentId의 하위 todo 추가
        case createSubTodo(parentId: UUID, todoItem: Todo)
        /// todo 수정
        case editTodo(Todo)
        /// todo 수정 완료 시
        case editTodoCompleted(Todo)
    }
    
    @Dependency(\.todoClient) var todoClient
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .editingChanged(isEditing):
                state.isEditing = isEditing
                return .none
                // todo 추가시 parentId의 여부에 따라서 다르게 동작
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
                // todo 수정시 editTodoCompleted를 통해서 변경된 todo로 즉시반영
            case .editButtonTapped:
                if let id = state.id {
                    let updatedTodo = Todo(id: id, title: state.title, content: state.content, dueDate: state.dueDate)
                    return .concatenate([
                        .send(.editTodo(updatedTodo)),
                        .send(.dismissSheet),
                        .send(.editTodoCompleted(updatedTodo))
                    ])
                } else {
                    return .send(.dismissSheet)
                }
            case let .crateTodo(todo):
                return .run { send in
                    todoClient.createTodoItem(todo)
                }
            case let .editTodo(todo):
                return .run { send in
                    do {
                        try todoClient.editTodoItem(todo)
                    } catch {
                    }
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

