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
    @ObservableState
    struct State {
        /// sheet가 편집중인 상태 여부
        var isEditing = true
        var title: String = ""
        var content: String = ""
        var dueDate: Date?
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case editingChanged(Bool)
        case editingCanelled
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .editingChanged(isEditing):                
                state.isEditing = isEditing
                return .none
            default:
                return .none
            }
        }
        ._printChanges()
    }
}
