//
//  PlanAPI.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 3/13/25.
//

import Foundation
import Moya

enum PlanAPI {
    case fetchCompletePlan(planId: Int, status: String)
}

extension PlanAPI: TargetType {
    var baseURL: URL {
        return URL(string: "\(SecretKey.baseUrl)/api/plans")!
    }
    
    var path: String {
        switch self {
        case let .fetchCompletePlan(planId, _):
            return "/\(planId)/complete"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchCompletePlan:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .fetchCompletePlan(_, status):
            return .requestCompositeParameters(bodyParameters: ["question": "조금 더 수월하게 도달하기 위해 어떤 점을 바꿔볼까요?",
                                                                "indicator": "시간 단축을 시도해볼래요."], bodyEncoding: JSONEncoding.default, urlParameters: ["status": status])
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["Content-type": "application/json"]
        }
    }
}
