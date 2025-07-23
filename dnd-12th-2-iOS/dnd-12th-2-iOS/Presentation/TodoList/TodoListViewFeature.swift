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
        // View의 사용자 인터랙션 관련 액션
        case view(ViewAction)
        // 외부(서버 등)에서 발생한 이벤트 처리용 액션
        case external(ExternalAction)
        // 네비게이션 관련 액션
        case destination(DestinationAction)
        
        enum ViewAction: BindableAction {
            // 바인딩 값 변경 (예: isShowTodoSheet)
            case binding(BindingAction<State>)
            // 시트 닫힘 처리
            case sheetDismiss
            // 시트 열기 처리
            case sheetPresent
            // 화면 등장 시 처리
            case viewOnAppear
            // Todo 셀 탭
            case todoCellTapped(Todo)
            // 마감일 설정 버튼 탭
            case setDueDateButtonTapped(Todo)
            // 완료 버튼 탭
            case completeButtonTapped(Todo)
        }
        
        enum DestinationAction {} // 네비게이션 상태 전용 액션
        
        enum ExternalAction {
            // Todo 완료 처리
            case todoComplete(Todo)
        }
        
        // 하위 시트 Feature 액션
        case todoSheetStore(TodoSheetFeature.Action)
        // 하위 리스트 Feature 액션
        case todoListAction(TodoListFeature.Action)
    }
    
    @Dependency(\.todoClient) var todoClient
    
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
                case let .completeButtonTapped(todoItem):
                    return .send(.external(.todoComplete(todoItem)))
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
            case .external(let action):
                switch action {
                case let .todoComplete(todo):
                    var newTodo = todo
                    newTodo.isCompleted.toggle()
                    return .run { send in
                        try todoClient.editTodoItem(newTodo)
                        await send(.todoListAction(.view(.viewonAppear)))
                    }
                }
            default:
                return .none
            }
        }
    }
}
