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
        /// 전체 투두 리스트
        var todoItems: [Todo] = []
        
        /// 특정 parent ID 하위의 할 일만 필터링할 때 사용
        var parentID: UUID?
        
        /// 추가하기 시트 표시 여부
        var isShowAddTodoSheet = false
        
        // 기본 이니셜라이저 (parentID 없음)
        init() {
            self.parentID = nil
        }
        
        // parentID가 있는 경우의 이니셜라이저
        init(parentID: UUID?) {
            self.parentID = parentID
        }
    }
    
    
    enum Action: TCAAction {
        // View에서 발생하는 사용자 액션
        case view(ViewAction)
        
        // 외부 의존성 또는 비동기 처리 액션
        case external(ExternalAction)
        
        // 화면 전환 등 네비게이션 관련 액션
        case destination(DestinationAction)
        
        enum ViewAction {
            // 뷰가 나타났을 때
            case viewonAppear
            
            // 할 일 목록을 받아왔을 때
            case responseTodoItem([Todo])
            
            // 할 일 셀을 탭했을 때
            case todoCellTapped(Todo)
        }
        
        enum ExternalAction {
            // 전체 할 일 목록 가져오기
            case fetchTodoItem
            
            // 특정 parentID 하위 할 일 목록 가져오기
            case fetchSubTodoItem(UUID)
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
                    if let parentId = state.parentID {
                        return .run { send in
                            await send(.external(.fetchSubTodoItem(parentId)))
                        }
                    } else {
                        return .run { send in
                            await send(.external(.fetchTodoItem))
                        }
                    }
                    
                case let .responseTodoItem(todoItem):
                    state.todoItems = todoItem
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
                case let .fetchSubTodoItem(id):
                    return .run { send in
                        let todos = try todoClient.fetchSubTodoItems(id)
                        await send(.view(.responseTodoItem(todos)))
                    }
                }
            default:
                return .none
            }
            return .none
        }
    }
}

