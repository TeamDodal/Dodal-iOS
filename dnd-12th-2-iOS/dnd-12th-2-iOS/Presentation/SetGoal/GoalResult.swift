//
//  GoalResult.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 3/9/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct GoalResult {
    @ObservableState
    struct State {
        var goalTitle: String
        var planTitle: String
        var startDate: Date
        var endDate: Date
        
        init(goalTitle: String, planTitle: String, startDate: Date, endDate: Date) {
            self.goalTitle = goalTitle
            self.planTitle = planTitle
            self.startDate = startDate
            self.endDate = endDate
        }
    }
    enum Action {
        case goToMain
    }
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
    }
}
