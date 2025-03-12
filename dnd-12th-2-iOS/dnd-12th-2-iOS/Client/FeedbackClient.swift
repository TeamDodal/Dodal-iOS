//
//  FeedbackClient.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 3/12/25.
//

import Foundation

import ComposableArchitecture
import Moya

struct FeedbackClient {
    var fetchFeedbacks: (String) async throws -> [Feedback]
    
    static let provider = MoyaProvider<FeedbackAPI>(session: Session(interceptor: AuthIntercepter.shared), plugins: [MoyaLoggingPlugin()])
}

extension FeedbackClient: DependencyKey {
    static let liveValue = Self (
        fetchFeedbacks: { type in
            do {
                let result: BaseResponse<FeedbackResDto> = try await provider.async.request(.fetchFeedbacks(type: type))
                guard let result = result.data else {
                    throw APIError.parseError
                }
                return result.elements.toDomain()
            } catch {
                throw error
            }
        }
    )
}

extension DependencyValues {
    var feedbackClient: FeedbackClient {
        get { self[FeedbackClient.self] }
        set { self[FeedbackClient.self] = newValue }
    }
}
