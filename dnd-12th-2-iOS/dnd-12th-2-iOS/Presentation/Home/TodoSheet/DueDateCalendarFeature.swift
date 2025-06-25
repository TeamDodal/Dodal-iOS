//
//  DueDateFeature.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 6/25/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct DueDateCalendarFeature {
    @ObservableState
    struct State {
        var dueDate: Date?
                                           
        var buttonTitle: String {
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
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case backButtonTapped
        case dueDateChanged(Date?)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.dueDate):
                if let dueDate = state.dueDate, dueDate < .now {
                    state.dueDate = nil
                    return .none
                }
                return .send(.dueDateChanged(state.dueDate))
            default:
                return .none
            }
        }
    }
}
