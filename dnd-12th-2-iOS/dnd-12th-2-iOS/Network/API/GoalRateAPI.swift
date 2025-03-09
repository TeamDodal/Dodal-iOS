//
//  GoalRateAPI.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 3/9/25.
//

import Foundation

import Moya

enum GoalRateAPI {
    case successRate(goalId: Int)
}

extension GoalRateAPI: TargetType {
    var baseURL: URL {
        return URL(string: "\(SecretKey.baseUrl)/api/goals")!
    }
    
    var path: String {
        switch self {
        case .successRate(let goalId):
            return "/\(goalId)/statistics"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .successRate:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .successRate:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}
