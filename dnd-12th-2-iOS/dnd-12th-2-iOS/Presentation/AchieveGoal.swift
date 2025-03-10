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
        var goalInfo: GoalResonseDto?
        var isLoading = false
        var error: String?
        
        init(goalId: Int) {
            self.goalId = goalId
        }
    }
    
    enum Action {
        case loadGoalInfo
        case goalInfoLoaded(GoalResonseDto)
        case goalInfoFailed(String)
    }
    
    @Dependency(\.achieveClient) var achieveClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadGoalInfo:
                state.isLoading = true
                state.error = nil
                return .run { [state] send in
                    do {
                        let goalInfo = try await achieveClient.fetchGoalRate(state.goalId)
                        await send(.goalInfoLoaded(goalInfo))
                    } catch {
                        await send(.goalInfoFailed("네트워크 오류: \(error)"))
                    }
                }
                
            case .goalInfoLoaded(let goalInfo):
                state.isLoading = false
                state.goalInfo = goalInfo
                return .none
                
            case .goalInfoFailed(let error):
                state.isLoading = false
                state.error = error
                return .none
            }
        }
    }
}
