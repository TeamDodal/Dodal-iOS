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
        default:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .fetchCompletePlan(_, status):
            return .requestParameters(parameters: ["status": status], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["Content-type": "application/json"]
        }
    }
}
