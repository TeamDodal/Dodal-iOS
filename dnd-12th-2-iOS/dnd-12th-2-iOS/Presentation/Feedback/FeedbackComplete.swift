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
        init(planInfo: Plan) {
            self.planInfo = planInfo
        }
    }
    
    enum CompleteType {
        case success
        case failure
    }
    enum Action {
        case backButtonTapped
        case nextButtonTapped
        case goToFeedback(planInfo: Plan)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .nextButtonTapped:
                return .send(.goToFeedback(planInfo: state.planInfo))
            default:
                return .none
            }
        }
    }
}
