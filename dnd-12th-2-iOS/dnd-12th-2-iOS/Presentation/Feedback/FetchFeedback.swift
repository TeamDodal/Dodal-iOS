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
        var planInfo: Plan
        var feedbacks: [Feedback]
        var selectedText = ""        
        var buttonDisabled: Bool {
            selectedText.isEmpty
        }
        let goalId: Int
        
        init(planInfo: Plan, feedbacks: [Feedback] = [], goalId: Int) {
            self.planInfo = planInfo
            self.feedbacks = feedbacks
            self.goalId = goalId
        }
    }
    
    enum Action {
        case loadFeedback
        case fetchFeedbackResponse([Feedback])
        case cellTapped(text: String)
        case completeButtonTapped
        case goToFeedbackResult(planInfo: Plan, goalId: Int)
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
            case let .cellTapped(text):
                state.selectedText = text
                return .none
            case .completeButtonTapped:
                if let feedback = state.feedbacks.first{
                    state.planInfo.question = feedback.question
                    state.planInfo.indicators = state.selectedText
                }
                return .send(.goToFeedbackResult(planInfo: state.planInfo, goalId: state.goalId))
            default:
                return  .none
            }
        }
    }
}
