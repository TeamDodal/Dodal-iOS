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
        let completeType: CompleteType
        let planInfo: Plan
        init(completeType: CompleteType, planInfo: Plan) {
            self.completeType = completeType
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
