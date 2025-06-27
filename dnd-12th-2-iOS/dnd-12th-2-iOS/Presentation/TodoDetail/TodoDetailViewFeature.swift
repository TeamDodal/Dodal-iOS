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
        /// 상단에 나타나는  todo
        var todoItem: Todo
        /// todoSheet 보임 여부
        var isShowAddTodoSheet = false
        /// 삭제 popup 보임 여부
        var isShowDeleteAlert = false
        /// todoSheet
        var todoSheetStore: TodoSheetFeature.State
        /// todoList
        var todoList: TodoListFeature.State
        /// todo 추가 가능 여부
        var isOverDepthLimit: Bool {
            todoItem.depth > 3
        }
        /// 마감일 설정 텍스트
        var dueDateButtonTitle: String {
            todoItem.dueDate?.toMonthDayString ?? "마감일"
        }
        /// 할일 상세정보를 보여주고 해당 todo의 하위 할일 목록을 보여줌
        /// - Parameter todoItem: 조회 하고싶은 todo 정보
        init(todoItem: Todo) {
            self.todoItem = todoItem
            self.todoSheetStore = .addSubTodo(parentId: todoItem.id)
            self.todoList = .init(parentID: todoItem.id)
        }
    }
    
    enum Action: ViewAction, TCAAction {
        /// 할일 생성 bottomSheet에서 일어나는 액션 정의
        case todoSheetStore(TodoSheetFeature.Action)
        /// 할일 목록에서 일어나는 액션 정의
        case todoList(TodoListFeature.Action)
        
        // view에서 일어나는 액션을 정의합니다.
        case view(ViewAction)
        // 외부의존성과 일어나는 액션을 정의합니다.
        case external(ExternalAction)
        
        // 뷰이동 관련 액션
        case destination(DestinationAction)
        
        enum ViewAction: BindableAction {
            /// 동적으로 바인딩 하기위한 액션
            case binding(BindingAction<State>)
            /// todoCell 터치하는 경우
            case todoCellTapped(Todo)
            /// todoCell의 마감일 설정 버튼 탭
            case dueDateButtonTapped(Todo)
            /// view가 나타났을때 액션
            case viewOnAppear
            /// 뒤로가기 버튼 탭
            case backButtonTapped
            /// 완료하기 버튼 탭
            case completeButtonTapped
            /// 하위 하일 추가 버튼탭
            case createTodoButtonTapped
            /// todoSheet 백그라운드 터치
            case backgroundTapped
            /// 삭제하기 버튼 탭
            case deleteButtonTapped
            /// 삭제하기 popup 활성화
            case showDeleteAlert
            /// 삭제하기 popup 비활성화
            case showDeleteAlertDismissed
            /// 수정하기 버튼 탭
            case editButtonTapped
        }
        
        enum DestinationAction {
            /// 현재 화면 제거 요청
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
        Scope(state: \.todoSheetStore, action: \.todoSheetStore) {
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
                    state.todoSheetStore = .init(parentId: state.todoItem.id)
                    state.isShowAddTodoSheet = true
                    return .none
                    // 백그라운드 터치시 bottomSheet를 제거하거나 편집중인 상태를 변경한다.
                    // todo 추가 => 편집계속, 삭제 버튼 활성화
                    // 마감일 설정 => bottomSheet 제거
                case .backgroundTapped:
                    guard let currentView = state.todoSheetStore.currentView else {
                        return .none
                    }
                    if currentView == .editTodo {
                        state.todoSheetStore.todoStore.isEditing = false
                    } else {
                        state.todoSheetStore = .init()
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
                    state.todoSheetStore = .editTodo(todo: state.todoItem)
                    state.isShowAddTodoSheet = true
                    return .none
                case let .dueDateButtonTapped(todo):
                    state.todoSheetStore = .setDueDate(todo: todo)
                    state.isShowAddTodoSheet = true
                    return .none
                default:
                    return .none
                }
                // MARK: - CreateTodo action
            case let .todoSheetStore(action):
                switch action {
                    // todo 추가 완료시 bottomSheet 제거하기
                case .editingCanelled, .crateTodoCompleted:
                    state.isShowAddTodoSheet = false
                    state.todoSheetStore = .init(parentId: state.todoItem.id)
                    return .run { send in
                        try await Task.sleep(for: .seconds(0.3))
                        await send(.todoList(.view(.viewonAppear)))
                    }
                    // todo 수정 완료시 즉시반영
                case let .todoStore(.editTodoCompleted(updatedTodo)):
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

