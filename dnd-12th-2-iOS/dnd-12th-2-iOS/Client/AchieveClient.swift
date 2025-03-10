//
//  AchieveClient.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 3/9/25.
//

import Foundation

import ComposableArchitecture
import Moya

struct AchieveClient {
    var fetchGoalRate: (Int) async throws -> GoalResonseDto
        static let provider = MoyaProvider<GoalRateAPI>(session: Session(interceptor: AuthIntercepter.shared), plugins: [MoyaLoggingPlugin()])
}

extension AchieveClient: DependencyKey {
    static let liveValue = Self(
        fetchGoalRate: { goalId in
            let result: BaseResponse<GoalResonseDto> = try await provider.async.request(.successRate(goalId: goalId))
            guard let data = result.data else {
                throw APIError.parseError
            }
            return data
        }
    )
}

extension DependencyValues {
    var achieveClient: AchieveClient {
        get { self[AchieveClient.self] }
        set { self[AchieveClient.self] = newValue }
    }
}
