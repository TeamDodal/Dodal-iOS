//
//  PlanClient.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 3/13/25.
//

import Foundation
import ComposableArchitecture
import Moya

struct PlanClient {
    var fetchCompletePlan: (Int, String) async throws -> ResultPlan
    static let provider = MoyaProvider<PlanAPI>(session: Session(interceptor: AuthIntercepter.shared), plugins: [MoyaLoggingPlugin()])
}

extension PlanClient: DependencyKey {
    static let liveValue = Self (
        fetchCompletePlan: { planId, status in
            do {
                let result: BaseResponse<PlanCompleteResDto> = try await provider.async.request(.fetchCompletePlan(planId: planId, status: status))
                guard let result = result.data else {
                    throw APIError.parseError
                }
                return result.toDomain()
            } catch {                
                throw error
            }
        }
    )
}

extension DependencyValues {
    var planClient: PlanClient {
        get { self[PlanClient.self] }
        set { self[PlanClient.self] = newValue }
    }
}
