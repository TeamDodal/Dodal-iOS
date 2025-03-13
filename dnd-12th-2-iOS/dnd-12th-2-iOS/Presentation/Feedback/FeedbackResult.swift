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
        var resultPlan: ResultPlan = .init(planId: 0, title: "", status: "", guide: "", completedDate: "")
        init(planInfo: Plan) {
            self.planInfo = planInfo
        }
    }
        
    enum Action {
        case fetchCompletePlan
        case fetchCompletePlanResponse(ResultPlan)
        case completeButtonTapped
    }
    @Dependency(\.planClient) var planClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchCompletePlan:
                            
                return .run { [state] send in
                    let result = try await planClient.fetchCompletePlan(state.planInfo)
                    await send(.fetchCompletePlanResponse(result))
                }                
            case let .fetchCompletePlanResponse(response):
                state.resultPlan = response
                return .none
            default:
                return .none
            }
        }
    }
}
