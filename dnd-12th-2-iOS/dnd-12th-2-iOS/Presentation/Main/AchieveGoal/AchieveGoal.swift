//
//  AchieveGoal.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 3/9/25.
//

import ComposableArchitecture

@Reducer
struct AchieveGoal {
    @ObservableState
    struct State {
        let goalId: Int
        var goalInfo: Goal?
        var isLoading = false
        var error: String?
        
        init(goalId: Int) {
            self.goalId = goalId
        }
    }
    
    enum Action {
        case loadGoalInfo
        case goalInfoLoaded(Goal?)
        case goalInfoFailed(String)
        case goToSetGoal
        case goToHome
    }
    
    @Dependency(\.goalClient) var goalClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadGoalInfo:
                state.isLoading = true
                state.error = nil
                return .run { [state] send in
                    let goalInfo = try await goalClient.fetchGoalRate(state.goalId)
                    await send(.goalInfoLoaded(goalInfo.first))
                }
            case .goalInfoLoaded(let goalInfo):
                state.isLoading = false
                state.goalInfo = goalInfo
                return .none
            case .goalInfoFailed(let error):
                state.isLoading = false
                state.error = error
                return .none
            case .goToSetGoal:
                return .none
            case .goToHome:
                return .none
            }
        }
    }
}
