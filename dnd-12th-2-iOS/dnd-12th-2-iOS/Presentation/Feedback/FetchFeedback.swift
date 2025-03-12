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
        var feedbacks: [Feedback] = []
    }
    
    enum Action {
        case loadFeedback
        case fetchFeedbackResponse([Feedback])
    }
    
    @Dependency(\.feedbackClient) var feedbackClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadFeedback:
                return .run { send in
                    let result = try await feedbackClient.fetchFeedbacks("SUCCESS")
                    await send(.fetchFeedbackResponse(result))
                }
            case let .fetchFeedbackResponse(response):
                state.feedbacks = response
                return .none
            }
        }
    }
}
