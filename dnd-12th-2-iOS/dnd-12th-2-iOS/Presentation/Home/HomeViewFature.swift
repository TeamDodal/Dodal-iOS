//
//  HomeViewFature.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 6/20/25.
//

import ComposableArchitecture

@Reducer
struct HomeViewFeature {
    @ObservableState
    struct State {
       var todoSheetState = TodoSheetFeature.State()
       var isShowTodoSheet = false
    }
    
    enum Action: ViewAction, TCAAction {
        case todoSheetAction(TodoSheetFeature.Action)
        
        case view(ViewAction)
        case external(ExternalAction)
        case destination(DestinationAction)
        
        enum ViewAction: BindableAction {
            case binding(BindingAction<State>)
            case sheetDismiss
            case sheetPresent
        }
        
        enum DestinationAction {
            
        }
        
        enum ExternalAction {}
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer(action: \.view)
        Scope(state: \.todoSheetState, action: \.todoSheetAction) {
            TodoSheetFeature()
        }
        Reduce { state, action in
            switch action {
            case .view(let viewAction):
                switch viewAction {
                case .sheetDismiss:
                    state.todoSheetState.isEditing = false
                    return .none
                case .sheetPresent:
                    state.isShowTodoSheet = true
                    return .none
                default:
                    return .none
                }
            case let .todoSheetAction(action):
                switch action {
                case .editingCanelled:
                    state.isShowTodoSheet = false
                    state.todoSheetState = .init()
                    return .none
                default:
                    return .none
                }
                
            default:
                return .none
            }
        }
    }
}
