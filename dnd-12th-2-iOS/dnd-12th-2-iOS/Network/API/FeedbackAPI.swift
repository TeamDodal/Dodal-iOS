//
//  FeedbackAPI.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 3/12/25.
//

import Foundation

import Moya

enum FeedbackAPI {
    case fetchFeedback(type: String)
}

extension FeedbackAPI: TargetType {
    var baseURL: URL {
        return URL(string: "\(SecretKey.baseUrl)/api")!
    }
    
    var path: String {
        switch self {
        case .fetchFeedback:
            return "/feedbacks"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchFeedback:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .fetchFeedback(type):
            return .requestParameters(parameters: ["type": type], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["Content-type": "application/json"]
        }
    }
}
