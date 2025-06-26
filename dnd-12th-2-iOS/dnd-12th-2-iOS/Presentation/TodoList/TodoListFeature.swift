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
        /// 투두리스트
        var todoItems: [Todo] = []
        /// 특정 id 하위의 할일 목록만 가져오기 위함
        var parentID: UUID?
        
        var isShowAddTodoSheet = false
        
        init() {
            self.parentID = nil
        }
        
        init (parentID: UUID?) {
            self.parentID = parentID
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
            /// 할일 목록 탭했을때
            case todoCellTapped(Todo)
            case showAddTodoButtonTapped
        }
        
        enum ExternalAction {
            /// 할일 목록 가져오기
            case fetchTodoItem
            case fetchSubTodoItem(UUID)
        }
        
        enum DestinationAction {
   
        }
    }
    
    @Dependency(\.todoClient) var todoClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                // MARK: - view
            case let .view(viewAction):
                switch viewAction {
                case .showAddTodoButtonTapped:
                    state.isShowAddTodoSheet = true
                    return .none
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

