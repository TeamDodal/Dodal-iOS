//
//  FeedbackComplete.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 3/13/25.
//

import ComposableArchitecture

@Reducer
struct FeedbackComplete {
    @ObservableState
    struct State {
        let planInfo: Plan
        let goalId: Int
        init(planInfo: Plan, goalId: Int) {
            self.planInfo = planInfo
            self.goalId = goalId
        }
    }
    
    enum CompleteType {
        case success
        case failure
    }
    enum Action {
        case backButtonTapped
        case nextButtonTapped
        case goToFeedback(planInfo: Plan, goalId: Int)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .nextButtonTapped:
                return .send(.goToFeedback(planInfo: state.planInfo, goalId: state.goalId))
            default:
                return .none
            }
        }
    }
}
