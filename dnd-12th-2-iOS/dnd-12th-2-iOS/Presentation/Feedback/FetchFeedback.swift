//
//  FetchFeedback.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 3/12/25.
//

import Foundation

import ComposableArchitecture

@Reducer
struct FetchFeedback {
    @ObservableState
    struct State {
        let planInfo: Plan
        var feedbacks: [Feedback]
        
        init(planInfo: Plan, feedbacks: [Feedback] = []) {
            self.planInfo = planInfo
            self.feedbacks = feedbacks
        }
    }
    
    enum Action {
        case loadFeedback
        case fetchFeedbackResponse([Feedback])
        case backButtonTapped
    }
    
    @Dependency(\.feedbackClient) var feedbackClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadFeedback:
                let requestText = state.planInfo.completeType == .success ? "SUCCESS" : "FAILURE"
                return .run { send in
                    let result = try await feedbackClient.fetchFeedbacks(requestText)
                    await send(.fetchFeedbackResponse(result))
                }
            case let .fetchFeedbackResponse(response):
                state.feedbacks = response
                return .none
            default:
                return  .none
            }
        }
    }
}
