//
//  FeedbackResult.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 3/13/25.
//
import ComposableArchitecture

@Reducer
struct FeedbackResult {
    @ObservableState
    struct State {
        let planInfo: Plan
        init(planInfo: Plan) {
            self.planInfo = planInfo
        }
    }
        
    enum Action {
        case fetchCompletePlan
        case fetchCompletePlanResponse(ResultPlan)
    }
    @Dependency(\.planClient) var planClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchCompletePlan:
                let status = state.planInfo.completeType == .success ? "success" : "failure"
                let planId = state.planInfo.planId
                return .run { send in
                   let result = try await planClient.fetchCompletePlan(planId, status)
                    await send(.fetchCompletePlanResponse(result))
                }                
            case let .fetchCompletePlanResponse(response):
                return .none
//            default:
//                return .none
            }
        }
    }
}
