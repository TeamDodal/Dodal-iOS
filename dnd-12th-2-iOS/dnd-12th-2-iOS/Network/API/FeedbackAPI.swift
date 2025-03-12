//
//  FeedbackAPI.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 3/12/25.
//

import Foundation

import Moya

enum FeedbackAPI {
    case fetchFeedbacks(type: String)
}

extension FeedbackAPI: TargetType {
    var baseURL: URL {
        return URL(string: "\(SecretKey.baseUrl)/api")!
    }
    
    var path: String {
        switch self {
        case .fetchFeedbacks:
            return "/feedbacks"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchFeedbacks:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .fetchFeedbacks(type):
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
