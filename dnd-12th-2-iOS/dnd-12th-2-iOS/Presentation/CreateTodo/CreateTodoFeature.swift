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
        var targetId: UUID?
        /// 편집 모드 여부
        var isEdit: Bool
        /// 할일 제목
        var title = ""
        /// 할일 상세 설명
        var content = ""
        /// 마감일
        var dueDate: Date?
        /// 현재 나타나는 화면 상태
        var viewFlow: TodoViewFlow = .addTodo
        /// 마감일 설정 버튼텍스트
        var setDueDateButtonText: String {
            guard let dueDate else { return "마감일 설정" }
            
            let calendar = Calendar.current
            let startOfToday = calendar.startOfDay(for: Date())
            let startOfTarget = calendar.startOfDay(for: dueDate)
            
            guard let diffDay = calendar.dateComponents([.day], from: startOfToday, to: startOfTarget).day,
                  diffDay > 0 else {
                return "마감일 설정"
            }
            
            return "\(dueDate.toMonthDayString)일까지 D-\(diffDay)일"
        }
        
        /// 홈에서 할일을 생성하는 경우에 사용합니다.
        /// - Returns: TodoState
        static func addTodoHomeView() -> State {
            .init(targetId: nil, isEdit: false, viewFlow: .addTodo)
        }
        
        /// 홈에서 마감일을 수정하는 경우에 사용합니다.
        /// - Parameters:
        ///   - targetId: 수정하려는 대상 투두의 id
        ///   - title: 할일 제목
        ///   - content: 할일 상세설명
        ///   - dueDate: 마감일
        /// - Returns: TodoState
        static func editDueDateHomeView(targetId: UUID?, title: String, content: String = "", dueDate: Date) -> State {
            .init(targetId: targetId, isEdit: true, title: title, content: content, selectedDate: dueDate, viewFlow: .calendar)
        }
        
        
        /// 상세화면에서 제목을 수정하는 경우에 사용합니다.
        /// - Parameters:
        ///   - targetId: 수정하고자하는 todoId
        ///   - title: 할일 제목
        ///   - content: 할일 상세설명
        ///   - dueDate: 마감일
        /// - Returns: TodoState
        static func editTitleDetailView(targetId: UUID?, title: String, content: String = "", dueDate: Date) -> State {
            .init(targetId: targetId, isEdit: true, title: title, content: content, selectedDate: dueDate, viewFlow: .addTodo)
        }
        
        /// 상세화면에서 마감일을 수정하는 경우에 사용합니다.
        /// - Parameters:
        ///   - parentId: 수정하고자하는 todoId
        ///   - title: 할일 제목
        ///   - content: 할일 상세설명
        ///   - dueDate: 마감일
        /// - Returns: TodoState
        static func editDueDateDetailView(targetId: UUID?, title: String, content: String = "", dueDate: Date) -> State {
            .init(targetId: targetId, isEdit: true, title: title, content: content, selectedDate: dueDate, viewFlow: .calendar)
        }
        
        /// 상세화면에서 하위 할일을 생성하는 경우에 사용합니다
        /// - Parameter targetId: 해당 id의 하위 할일을 추가합니다
        /// - Returns: TodoState
        static func addTodoDetailView(targetId: UUID?) -> State {
            .init(targetId: targetId, isEdit: false, viewFlow: .addTodo)
        }
        
        private init(
            targetId: UUID?,
            isEdit: Bool,
            title: String = "",
            content: String = "",
            selectedDate: Date? = nil,
            viewFlow: TodoViewFlow
        ) {
            self.targetId = targetId
            self.isEdit = isEdit
            self.title = title
            self.content = content
            self.dueDate = selectedDate
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
            case addTodoCompleted
            /// 수정하기 완료 액션
            case editTodoCompleted
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
                case .binding(\.dueDate):
                    if let selectedDate = state.dueDate {
                        if selectedDate < Date() {
                            state.dueDate = nil
                        }
                    }
                    return .none
                case .addTodoButtonTapped:
                    // targetId에 해당하는 todo 수정
                    if state.isEdit, let uuid = state.targetId {
                        return .concatenate([
                            .send(.external(.editTodoItem(id: uuid, title: state.title, content: state.content, selectedDate: state.dueDate))),
                            .send(.view(.editTodoCompleted))
                        ])
                    }
                    else if let uuid = state.targetId {
                        return .concatenate([
                            .send(.external(.addSubTodoItem(id: uuid))),
                            .send(.view(.addTodoCompleted))
                        ])
                    } else {
                        return .concatenate([
                            .send(.external(.addTodoItem)),
                            .send(.view(.addTodoCompleted))
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
                        todoClient.createTodoItem(state.title, state.content, state.dueDate)
                    }
                case let .addSubTodoItem(id):
                    return .run { [state] send in
                        try todoClient.createSubTodoItem(id, state.title, nil, nil)
                    }
                case let .editTodoItem(id, title, content, dueDate):
                    return .run { send in
                        try todoClient.editTodoItem(id, title, content, dueDate, false)
                    }
                }
            }
            
        }
    }
}
