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
        /// todo 추가, 수정
        case editTodo
        /// 마감일 설정
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
        /// sheet에 나타날 화면 스택 관리
        var viewStack: [ViewState] = []
        /// 현재 보여질 화면
        var currentView: ViewState? {
            viewStack.last
        }
        /// todo 수정 추가시
        var todoStore: TodoEditorFeature.State
        
        var calendarStore: DueDateCalendarFeature.State
        /// rootView 확인 용도
        var isRootView: Bool {
            viewStack.count <= 1
        }
        
        /// todo 수정
        init(viewStack: [ViewState] = [.editTodo], todo: Todo, isEdit: Bool = false) {
            self.viewStack = viewStack            
            self.todoStore = .init(isEdit: isEdit, id: todo.id, title: todo.title, content: todo.content ?? "", dueDate: todo.dueDate)
            self.calendarStore = .init(dueDate: todo.dueDate)
        }
        
        ///  todo 생성
        init() {
            self.viewStack = [.editTodo]
            self.todoStore = .init()
            self.calendarStore = .init()
        }
        
        init(parentId: UUID) {
            self.viewStack = [.editTodo]
            self.todoStore = .init(parentId: parentId)
            self.calendarStore = .init()
        }
        
        
        /// 마감일만 설정하는 경우에 사용
        /// - Parameter todo: 수정할 todo
        static func setDueDate(todo: Todo) -> State {
            .init(viewStack: [.setDueDate], todo: todo)
        }
        
        /// 새로운 todo를 추가하는 경우
        static func addTodo() -> State {
            .init()
        }
        
        /// 하위의 todo를 추가하는 경우
        /// - Parameter parentId: parentId 하위의 todo를 추가
        static func addSubTodo(parentId: UUID) -> State {
            .init(parentId: parentId)
        }
        
        /// todo 수정시 사용
        /// - Parameter todo: 수정하려는 todo
        static func editTodo(todo: Todo) -> State {
            .init(viewStack: [.editTodo], todo: todo, isEdit: true)
        }
    }
    
    enum Action: BindableAction {
        /// 동적으로 바인딩 하기위한 액션
        case binding(BindingAction<State>)
        /// todoStore 액션
        case todoStore(TodoEditorFeature.Action)
        /// calendar 액션
        case calendarStore(DueDateCalendarFeature.Action)
        /// todo 편집 완료 또는 취소시
        case editingCanelled
        /// todo 추가 완료 시
        case crateTodoCompleted
        /// 뒤로가기 버튼 탭
        case backButtonTapped
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Scope(state: \.todoStore, action: \.todoStore) {
            TodoEditorFeature()
        }
        Scope(state: \.calendarStore, action: \.calendarStore) {
            DueDateCalendarFeature()
        }
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                if !state.isRootView {
                    state.viewStack.removeLast()
                }
                return .none
            case let .todoStore(action):
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
            case let .calendarStore(action):
                switch action {
                case let .dueDateChanged(dueDate):
                    state.todoStore.dueDate = dueDate
                    return .none
                    /// rootView인 경우 즉시 todo 수정
                case let .setDueDateCompleted(dueDate):
                    if state.isRootView {                        
                        return .concatenate([
                            .send(.todoStore(.setDueDate(dueDate))),
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
