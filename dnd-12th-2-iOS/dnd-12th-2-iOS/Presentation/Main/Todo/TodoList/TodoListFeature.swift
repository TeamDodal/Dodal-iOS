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
        var todoItems: [Todo] = []
        
        var isShowDdayPopup = false
        
        // 마감일 하루전
        var dDayTodos: [Todo] {
            return todoItems.filter { todo in
                guard let dueDate = todo.dueDate else { return false }
                return calendar.isDateInTomorrow(dueDate)
            }
        }
        
        // 이번주
        var thisWeekTodos: [Todo] {
            guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: Date()) else {
                return []
            }
            return todoItems.filter { todo in
                guard let dueDate = todo.dueDate else { return false }
                return weekInterval.contains(dueDate)
            }.sorted { $0.dueDate ?? $0.createDate < $1.dueDate ?? $1.createDate }
        }
        
        var recentTodos: [Todo] {
            return todoItems.sorted { $0.updateDate > $1.updateDate }
        }
    }
    
    enum Action: TCAAction {
        case view(ViewAction)
        case external(ExternalAction)
        case destination(DestinationAction)
        
        enum ViewAction {
            case viewonAppear
            case responseTodoItem([Todo])
            case todoCellTapped(Todo)
            case dismissDdayPopup
            case showDdayPopup
        }
        
        enum ExternalAction {
            case fetchTodoItem
        }
        
        enum DestinationAction {}
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
                default:
                    return .none
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

