//
//  FetchPlan.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 3/3/25.
//

import Foundation
import ComposableArchitecture

struct Section: Hashable {
    let key: String
    let date: String
}

@Reducer
struct FetchPlan {
    @ObservableState
    struct State {
        let goalId: Int
        var planGroup: [[Section: [Plan]]] = [[:]]
        var scrollKey = ""
        var renderKey = ""
        
        var isTipHidden: Bool {
            return !(planGroup.flatMap { $0.values.flatMap { $0 } }.count <= 2)
        }
        
        init(goalId: Int) {
            self.goalId = goalId
        }
    }
    
    enum Action {
        case requestPlan(Date)
        case fetchPlans(Date)
        case fetchPlanResponse([Plan])
        case responseScrollId(Date)
        case setRenderKey
    }
    
    @Dependency(\.goalClient) var goalClient
    let calendar = Calendar.current
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .responseScrollId(date):
                state.scrollKey = date.formatted("yyyyMMdd")
                return .none
            case let .requestPlan(date):
                return .send(.fetchPlans(date))
            case let .fetchPlans(date):
                return  .concatenate([
                    .run { [state] send in
                        let result = try await goalClient.fetchPlans(state.goalId, date.toShortDateFormat(), 3)
                        await send(.fetchPlanResponse(result))
                    },
                    .send(.setRenderKey)
                ])
            case let .fetchPlanResponse(response):
                return self.groupByStartDate(&state, plan: response)
            case .setRenderKey:
                state.renderKey = UUID().uuidString
                return .none
            }
        }
    }
}

extension FetchPlan {
    // 시작날짜를 기준으로 정렬
    func groupByStartDate( _  state: inout State, plan: [Plan]) -> Effect<Action> {
        var groupedPlan : [Date: [Plan]] = [:]
        for plan in plan {
            // startDate부터 endDate 사이의 날짜로 key를 만든다
            //  key의 배열에 해당 plan을 update한다
            let startDate = plan.startDate.toDate()
            let endDate = plan.endDate.toDate()
            let startDateResult = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: startDate)
            let endDateResult = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: endDate) ?? Date()
            var currentDate = startDateResult ?? Date()
            
            while currentDate <= endDateResult {
                groupedPlan[currentDate, default: []].append(plan)
                
                guard let nextDay = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
                currentDate = nextDay
            }
        }
        
        state.planGroup = groupedPlan.sorted { $0.key < $1.key}
            .map { (key, value) -> Dictionary<Section, [Plan]> in
                let date = key.formatted("MM월 dd일")
                let uniqueKey = key.formatted("yyyyMMdd")
                let key = Section(key: uniqueKey, date: date)
                return [key: value]
         }
        return .none
    }
}
