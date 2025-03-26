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
        let goalId: Int
        var resultPlan: [ResultPlan] = []
        init(planInfo: Plan, goalId: Int) {
            self.planInfo = planInfo
            self.goalId = goalId
        }
    }
        
    enum Action {
        case fetchCompletePlan
        case fetchCompletePlanResponse(ResultPlan)
        case fetchPlanHistory
        case fetchPlanHistoryResponse([ResultPlan])
        case completeButtonTapped
        case improveButtonTapped
        case goToImprovePlan(planInfo: Plan, goalId: Int, planId: Int)
    }
    
    @Dependency(\.planClient) var planClient
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                // 계획 완료요청
            case .fetchCompletePlan:
                return .run { [state] send in
                    let result = try await planClient.fetchCompletePlan(state.planInfo)
                    await send(.fetchCompletePlanResponse(result))
                }                
            case let .fetchCompletePlanResponse(response):                
                state.resultPlan.append(response)
                return .send(.fetchPlanHistory)
                // 계획 가져오기
            case .fetchPlanHistory:
                return .run { [state] send in
                    let result = try await planClient.fetchPlanHistory(state.planInfo.planId)
                    await send(.fetchPlanHistoryResponse(result))
                }
            case let .fetchPlanHistoryResponse(response):
                let newArray = response.reversed() + state.resultPlan                
                state.resultPlan = Array(newArray.reduce(into: [Int: ResultPlan]()) { result, item in
                    result[item.planId] = item
                }.values).sorted { $0.completedDate.toDate() < $1.completedDate.toDate() }
                return .none
            case .improveButtonTapped:
                return .send(.goToImprovePlan(planInfo: state.planInfo, goalId: state.goalId, planId: state.planInfo.planId))
            default:
                return .none
            }
        }
        ._printChanges()
    }
}
