//
//  TodoFeature.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 5/10/25.
//

import Foundation

import ComposableArchitecture

enum TodoViewFlow {
    case addTodo
    case calendar
}

@Reducer
struct TodoFeature {
    @ObservableState
    struct State {
        var parentId: UUID?
        var isEdit: Bool
        var title = ""
        var content = ""
        var selectedDate: Date?
        var viewFlow: TodoViewFlow = .addTodo
        
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
        
        init(parentId: UUID? = nil,
             title: String = "",
             isEdit: Bool) {
            self.parentId = parentId
            self.isEdit = isEdit
            self.title = title
        }
    }
    
    enum Action: ViewAction, TCAAction {
        // view에서 일어나는 액션을 정의합니다.
        case view(ViewAction)
        
        // 외부의존성과 일어나는 액션을 정의합니다.
        case external(ExternalAction)
        
        // 뷰이동 관련 액션
        case destination(DestinationAction)
        
        enum ViewAction: BindableAction {
            case binding(BindingAction<State>)
            case addTodoButtonTapped
            case addTodoComplete
            case setDueDateButtonTapped
            case backButtonTapped
        }
        
        enum DestinationAction {}
        
        enum ExternalAction {
            case addTodoItem
            case addSubTodoItem(id: UUID)
            case editTodoItem(id: UUID, title: String)
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
                            .send(.external(.editTodoItem(id: uuid, title: state.title))),
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
                case let .editTodoItem(id, title):
                    return .run { send in
                        try todoClient.editTodoItem(id, title, nil, nil)
                    }
                }
            }
            
        }
    }
}

