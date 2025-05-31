//
//  TodoListFeature.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 5/10/25.
//

import Foundation

import ComposableArchitecture

@Reducer
struct TodoListFeature {
        
    @ObservableState
    struct State {
        private let calendar = Calendar.current
        /// 투두리스트
        var todoItems: [Todo] = []
        
        /// 마감일 하루전 팝업 여부
        var isShowDdayPopup = false
        
        /// 마감일 하루전 할일 목록
        var dDayTodos: [Todo] {
            return todoItems.filter { todo in
                guard let dueDate = todo.dueDate else { return false }
                return calendar.isDateInTomorrow(dueDate)
            }
        }
        /// 이번주 할일 목록
        var thisWeekTodos: [Todo] {
            guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: Date()) else {
                return []
            }
            return todoItems.filter { todo in
                guard let dueDate = todo.dueDate else { return false }
                return weekInterval.contains(dueDate)
            }.sorted { $0.dueDate ?? $0.createDate < $1.dueDate ?? $1.createDate }
        }
        
        /// 최근 할일 목록
        /// updateDate 기준으로 최신순 정렬
        var recentTodos: [Todo] {
            return todoItems.sorted { $0.updateDate > $1.updateDate }
        }
    }
    
    enum Action: TCAAction {
        case view(ViewAction)
        case external(ExternalAction)
        case destination(DestinationAction)
        
        /// View에서 일어나는 액션을 정의
        enum ViewAction {
            /// 뷰가 나타났을때 액션
            case viewonAppear
            /// 할일 목록 받아왔을때
            case responseTodoItem([Todo])
            /// 마감일 하루전 팝업 닫기
            case dismissDdayPopup
            /// 마감일 하루전 팝업 열기
            case showDdayPopup
            /// 할일 목록 탭했을때
            case todoCellTapped(Todo)
        }
        
        enum ExternalAction {
            /// 할일 목록 가져오기
            case fetchTodoItem
        }
        
        enum DestinationAction {
            /// 할일 목록 상세로 이동
            case goToTodoDetailView(Todo)
        }
    }
    
    @Dependency(\.todoClient) var todoClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                // MARK: - view
            case let .view(viewAction):
                switch viewAction {
                case .viewonAppear:
                    return .run { send in
                        await send(.external(.fetchTodoItem))
                    }
                case let .responseTodoItem(todoItem):
                    state.todoItems = todoItem
                    return .run { send in
                        try await Task.sleep(for: .seconds(0.5))
                        await send(.view(.showDdayPopup), animation: .easeInOut)
                        }
                case .showDdayPopup:
                    state.isShowDdayPopup = true
                    return .none
                case .dismissDdayPopup:
                    state.isShowDdayPopup = false
                    return .none
                case let .todoCellTapped(todo):
                    return .send(.destination(.goToTodoDetailView(todo)))
                }
                // MARK: - external
            case let .external(externalAction):
                switch externalAction {
                case .fetchTodoItem:
                    return .run { send in
                        let todos = try todoClient.fetchTodoItems()
                        await send(.view(.responseTodoItem(todos)))
                    }
                }
            default:
                return .none
            }
        }
    }
}

