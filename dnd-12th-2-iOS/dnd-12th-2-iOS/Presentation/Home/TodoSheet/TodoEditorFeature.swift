//
//  TodoFeature.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 6/24/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct TodoEditorFeature {
    @ObservableState
    struct State {
        /// 할일 제목
        var title: String = ""
        
        /// 할일 상세 설명
        var content: String = ""
        
        /// 마감일
        var dueDate: Date?
        
        /// 편집중인 상태 여부
        var isEditing = true
        
        var dueDateButtonTitle: String {
            dueDate?.toMonthDayString ?? "마감일"
        }
        
        var isSubmitButtonEnabled: Bool {
            !title.isEmpty
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case editingChanged(Bool)
        case editingCanelled
        case dueDateButtonTapped
        
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
    }
}

