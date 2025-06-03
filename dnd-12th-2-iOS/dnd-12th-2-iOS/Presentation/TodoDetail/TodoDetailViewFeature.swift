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
        var todo: CreateTodoFeature.State
        var todoList: TodoListFeature.State
        
        var isOverDepthLimit: Bool {
            todoItem.depth > 3
        }
        
        init(todoItem: Todo) {
            self.todoItem = todoItem
            self.todo = .addTodoDetailView(targetId: todoItem.id)
            self.todoList = .init(parentID: todoItem.id)
        }
    }
    
    enum Action: ViewAction, TCAAction {
        case todo(CreateTodoFeature.Action)
        case todoList(TodoListFeature.Action)
        
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
            case setDueDateButtonTapped(Todo)
            case editButtonTapped
            case deleteButtonTapped
            case viewOnAppear
            case showDeleteAlert
            case showDeleteAlertDismissed
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
        BindingReducer(action: \.view)
        Scope(state: \.todo, action: \.todo) {
            CreateTodoFeature()
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
                case .showAddTodoButtonTapped:
                    state.todo = .addTodoDetailView(targetId: state.todoItem.id)
                    state.isShowAddTodoSheet = true
                    return .none
                    // 현재 Todo 수정
                case .editButtonTapped:
                    state.todo = .editTitleDetailView(targetId: state.todoItem.id,
                                                      title: state.todoItem.title,
                                                      content: state.todoItem.content ?? "",
                                                      dueDate: state.todoItem.dueDate ?? Date()
                    )
                    state.isShowAddTodoSheet = true
                    return .none
                    // 하위 Todo 마감일 수정
                case let .setDueDateButtonTapped(todo):
                    state.todo = .editDueDateDetailView(targetId: todo.id,
                                                        title: todo.title,
                                                        content: todo.content ?? "",
                                                        dueDate: todo.dueDate ?? Date())
                    state.isShowAddTodoSheet = true
                    return .send(.todoList(.view(.viewonAppear)))
                case .deleteButtonTapped:
                    return .send(.external(.deleteTodoItem(id: state.todoItem.id)))
                case .viewOnAppear:
                    return .send(.todoList(.view(.viewonAppear)))
                case .showDeleteAlert:
                    state.isShowDeleteAlert = true
                    return .none
                case .showDeleteAlertDismissed:
                    state.isShowDeleteAlert = false
                    return .none
                default:
                    return .none
                }
                // MARK: - CreateTodo action
            case let .todo(todoAction):
                switch todoAction {
                    // todo 생성시 리스트 불러오기
                case .view(.addTodoCompleted):
                    state.isShowAddTodoSheet = false
                    return .send(.todoList(.view(.viewonAppear)))
                    // todo 수정시 현재 todo 상태를 업데이트
                case .view(.editTodoCompleted):
                    // 현재 Todo의 id와 targetId가 같다면 현재의 Todo를 업데이트
                    if state.todo.targetId == state.todoItem.id {
                        state.todoItem.title = state.todo.title
                        state.todoItem.content = state.todo.content
                        state.todoItem.dueDate = state.todo.dueDate
                        state.isShowAddTodoSheet = false
                        return .none
                    } else {
                        // 그게 아니라면 하위 투두의 리스트를 다시불러옴
                        state.isShowAddTodoSheet = false
                        return .send(.todoList(.view(.viewonAppear)))
                    }
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
                }
            case let .destination(destination):
                switch destination {
                case .popNavigationStack:
                    return .none
                }
            default: return .none
            }
        }
        ._printChanges()
    }
}
