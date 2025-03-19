//
//  GoalClient.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 3/3/25.
//

import Foundation
import ComposableArchitecture
import Moya

struct GoalClient {
    var makeGoal: (GoalInfo) async throws -> Void
    var makePlan: (Int, PlanInfo) async throws -> Void
    var fetchGoal: () async throws -> [Goal]
    var deleteGoal: (Int) async throws -> Void
    var fetchWeeklyGoal: (Int, String) async throws -> [Day]
    var fetchPlans: (Int, String, Int) async throws -> [Plan]
    var achieveGoal: (Int) async throws -> Void
    var fetchGoalRate: (Int) async throws -> [Goal]
    var improvePlan: (Int, Int, PlanInfo) async throws -> Void
    
    static let provider = MoyaProvider<GoalAPI>(session: Session(interceptor: AuthIntercepter.shared), plugins: [MoyaLoggingPlugin()])
}

extension GoalClient: DependencyKey {
    static let liveValue = Self (
        makeGoal: { goalInfo in
            do {
                try await provider.async.requestPlain(.makeGoalWithPlan(goalInfo.toDto()))
            } catch {
                throw error
            }
        },
        makePlan: { goalId, planInfo in
            do {
                try await provider.async.requestPlain(.makePlan(goalID: goalId, planReqDto: planInfo.toDto()))
            } catch {
                throw error
            }
        }, fetchGoal: {
            do {
                let result: BaseResponse<[GoalResonseDto]> = try await provider.async.request(.fetchGoal)
                guard let result = result.data else {
                    throw APIError.parseError
                }
                return result.toDomain()
            } catch {
                throw error
            }
        } , deleteGoal: { goalId in
            do {
                try await provider.async.requestPlain(.deleteGoal(goalID: goalId))                
            } catch {
                throw error
            }
        }, fetchWeeklyGoal: { goalId, date in
            do {
                let result: BaseResponse<[StatisticsResponseDto]> = try await provider.async.request(.fetchWeeklyGoal(goalId, date))
                guard let data = result.data else {
                    throw APIError.parseError
                }
                return data.toDomain()
            } catch {
                throw error
            }
        }, fetchPlans: { goalId, date, range in
            do {
                let result: BaseResponse<[PlanResponseDto]> = try await provider.async.request(.fetchPlans(goalId: goalId, date: date, range: range))
                guard let data = result.data else {
                    throw APIError.parseError
                }
                return data.toDomain()
            } catch {
                throw error
            }
        }, achieveGoal: { goalId in
            do {
                try await provider.async.requestPlain(.achieveGoal(goalId: goalId))
            } catch {
                throw error
            }
        }, fetchGoalRate: { goalId in
            do {
                let result: BaseResponse<GoalResonseDto> = try await provider.async.request(.fetchSuccessRate(goalId: goalId))
                guard let result = result.data else {
                    throw APIError.parseError
                }
                return [result.toElement()]
            } catch {
                throw error
            }
        }, improvePlan: { goalId, planId, planInfo in
            do {
                try await provider.async.requestPlain(.improvePlan(
                    goalId: goalId,
                    planId: planId,
                    planReqDto: planInfo.toDto()
                ))
            } catch {
                throw error
            }
        }
    )
}

extension DependencyValues {
    var goalClient: GoalClient {
        get { self[GoalClient.self] }
        set { self[GoalClient.self] = newValue }
    }
}
