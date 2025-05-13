//
//  TodoFeature.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 5/10/25.
//

import Foundation

import ComposableArchitecture

@Reducer
struct TodoFeature {
    @ObservableState
    struct State {
        var parentId: UUID?
        var title = ""
        
        init(parentId: UUID? = nil) {
            self.parentId = parentId
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
        }
        
        enum DestinationAction {}
        
        enum ExternalAction {}
    }
    
    @Dependency(\.todoClient) var todoClient
    
    var body: some Reducer<State, Action> {
        BindingReducer(action: \.view)
        Reduce { state, action in
            switch action {
                // MARK: - View
            case let .view(viewAction):
                switch viewAction {
                case .binding:
                    return .none
                case .addTodoButtonTapped:
                    return .run { [state] send in
                        do {
                            if let uuid = state.parentId {
                                try  todoClient.createSubTodoItem(uuid, state.title, nil, nil)
                            } else {
                                todoClient.createTodoItem(state.title, nil, nil)
                            }
                            await send(.view(.addTodoComplete))
                        } catch {
                            
                        }
                    }
                default:
                    return .none
                }
            }
            
        }
    }
}
