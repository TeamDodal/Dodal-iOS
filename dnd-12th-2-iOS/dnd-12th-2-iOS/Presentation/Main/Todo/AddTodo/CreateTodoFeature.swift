//
//  TodoFeature.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 5/10/25.
//

import Foundation

import ComposableArchitecture

enum TodoViewFlow {
    /// 할일 추가 또는 수정
    case addTodo
    /// 마감일 설정 캘린더
    case calendar
}

@Reducer
struct CreateTodoFeature {
    @ObservableState
    struct State {
        /// todo 수정시 설정
        var parentId: UUID?
        /// 편집 모드 여부
        var isEdit: Bool
        /// 할일 제목
        var title = ""
        /// 할일 상세 설명
        var content = ""
        /// 마감일
        var selectedDate: Date?
        /// 현재 나타나는 화면 상태
        var viewFlow: TodoViewFlow = .addTodo
        /// 마감일 설정 버튼텍스트
        var setDueDateButtonText: String {
            guard let selectedDate else { return "마감일 설정" }
            
            let calendar = Calendar.current
            let startOfToday = calendar.startOfDay(for: Date())
            let startOfTarget = calendar.startOfDay(for: selectedDate)
            
            guard let diffDay = calendar.dateComponents([.day], from: startOfToday, to: startOfTarget).day,
                  diffDay > 0 else {
                return "마감일 설정"
            }
            
            return "\(selectedDate.toMonthDayString)일까지 D-\(diffDay)일"
        }
        
        /// 홈에서 할일을 생성하는 경우에 사용합니다.
        /// - Returns: TodoState
        static func addTodoHomeView() -> State {
            .init(parentId: nil, isEdit: false, viewFlow: .addTodo)
        }
        
        /// 홈에서 마감일을 수정하는 경우에 사용합니다.
        /// - Parameters:
        ///   - title: 할일 제목
        ///   - content: 할일 상세설명
        ///   - dueDate: 마감일
        /// - Returns: TodoState
        static func editDueDateHomeView(parentId: UUID?, title: String, content: String = "", dueDate: Date) -> State {
            .init(parentId: parentId, isEdit: true, title: title, content: content, selectedDate: dueDate, viewFlow: .calendar)
        }
        
        
        /// 상세화면에서 제목을 수정하는 경우에 사용합니다.
        /// - Parameters:
        ///   - parentId: 수정하고자하는 todoId
        ///   - title: 할일 제목
        ///   - content: 할일 상세설명
        ///   - dueDate: 마감일
        /// - Returns: TodoState
        static func editTitleDetailView(parentId: UUID?, title: String, content: String = "", dueDate: Date) -> State {
            .init(parentId: parentId, isEdit: true, title: title, content: content, selectedDate: dueDate, viewFlow: .addTodo)
        }
        
        /// 상세화면에서 마감일을 수정하는 경우에 사용합니다.
        /// - Parameters:
        ///   - parentId: 수정하고자하는 todoId
        ///   - title: 할일 제목
        ///   - content: 할일 상세설명
        ///   - dueDate: 마감일
        /// - Returns: TodoState
        static func editDueDateDetailView(parentId: UUID?, title: String, content: String = "", dueDate: Date) -> State {
            .init(parentId: parentId, isEdit: true, title: title, content: content, selectedDate: dueDate, viewFlow: .calendar)
        }
        
        /// 상세화면에서 하위 할일을 생성하는 경우에 사용합니다
        /// - Parameter parentId: 상위 투두  Id
        /// - Returns: TodoState
        static func addTodoDetailView(parentId: UUID?) -> State {
            .init(parentId: parentId, isEdit: false, viewFlow: .addTodo)
        }
        
        private init(
            parentId: UUID?,
            isEdit: Bool,
            title: String = "",
            content: String = "",
            selectedDate: Date? = nil,
            viewFlow: TodoViewFlow
        ) {
            self.parentId = parentId
            self.isEdit = isEdit
            self.title = title
            self.content = content
            self.selectedDate = selectedDate
            self.viewFlow = viewFlow
        }
    }
    
    enum Action: ViewAction, TCAAction {
        /// view에서 일어나는 액션을 정의합니다.
        case view(ViewAction)
        /// 외부의존성과 일어나는 액션을 정의합니다.
        case external(ExternalAction)
        /// 뷰이동 관련 액션
        case destination(DestinationAction)
        
        enum ViewAction: BindableAction {
            case binding(BindingAction<State>)
            /// 생성하기 버튼 터치
            case addTodoButtonTapped
            /// 생성하기 완료 액션
            case addTodoComplete
            /// 마감일 설정 버튼 터치
            case setDueDateButtonTapped
            /// 뒤로가기 버튼 터치
            case backButtonTapped
        }
        
        enum DestinationAction {}
        
        enum ExternalAction {
            /// 새로운 할일을 생성
            case addTodoItem
            /// 특정 할일 하위목록으로 할일 생성
            case addSubTodoItem(id: UUID)
            /// id에 해당하는 할일 수정
            case editTodoItem(id: UUID, title: String, content: String, selectedDate: Date?)
        }
    }
    
    @Dependency(\.todoClient) var todoClient
    
    var body: some Reducer<State, Action> {
        BindingReducer(action: \.view)
        Reduce { state, action in
            switch action {
                // MARK: - view
            case let .view(viewAction):
                switch viewAction {
                case .binding(\.selectedDate):
                    if let selectedDate = state.selectedDate {
                        if selectedDate < Date() {
                            state.selectedDate = nil
                        }
                    }
                    return .none
                case .addTodoButtonTapped:
                    if state.isEdit, let uuid = state.parentId {
                        return .concatenate([
                            .send(.external(.editTodoItem(id: uuid, title: state.title, content: state.content, selectedDate: state.selectedDate))),
                            .send(.view(.addTodoComplete))
                        ])
                    }
                    else if let uuid = state.parentId {
                        return .concatenate([
                            .send(.external(.addSubTodoItem(id: uuid))),
                            .send(.view(.addTodoComplete))
                        ])
                    } else {
                        return .concatenate([
                            .send(.external(.addTodoItem)),
                            .send(.view(.addTodoComplete))
                        ])
                    }
                case .setDueDateButtonTapped:
                    state.viewFlow = .calendar
                    return .none
                case .backButtonTapped:
                    state.viewFlow = .addTodo
                    return .none
                default: return .none
                }
                // MARK: - external
            case let .external(externalAction):
                switch externalAction {
                case .addTodoItem:
                    return .run { [state] send in
                        todoClient.createTodoItem(state.title, state.content, state.selectedDate)
                    }
                case let .addSubTodoItem(id):
                    return .run { [state] send in
                        try todoClient.createSubTodoItem(id, state.title, nil, nil)
                    }
                case let .editTodoItem(id, title, content, dueDate):
                    return .run { send in
                        try todoClient.editTodoItem(id, title, content, dueDate)
                    }
                }
            }
            
        }
    }
}
