//
//  PlanAPI.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 3/13/25.
//

import Foundation
import Moya

enum PlanAPI {
    case fetchCompletePlan(planInfo: Plan)
    case fetchPlanHistory(planId: Int)
    case deletePlan(planId: Int)
}

extension PlanAPI: TargetType {
    var baseURL: URL {
        return URL(string: "\(SecretKey.baseUrl)/api/plans")!
    }
    
    var path: String {
        switch self {
        case let .fetchCompletePlan(planInfo):
            return "/\(planInfo.planId)/complete"
        case let .deletePlan(planId):
            return "/\(planId)"
        case let .fetchPlanHistory(planId):
            return "/\(planId)/history"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchCompletePlan:
            return .post
        case .deletePlan:
            return .delete
        case .fetchPlanHistory:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .fetchCompletePlan(planInfo):
            let status = planInfo.completeType == .success ? "success" : "failure"
            return .requestCompositeParameters(bodyParameters: ["question": planInfo.question,
                                                                "indicator": planInfo.indicators], bodyEncoding: JSONEncoding.default, urlParameters: ["status": status])
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["Content-type": "application/json"]
        }
    }
}
