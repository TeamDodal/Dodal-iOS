//
//  GoalAPI.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 3/3/25.
//

import Foundation
import Moya

enum GoalAPI {
    case makeGoalWithPlan(GoalReqDto)
    case makePlan(goalID: Int, planReqDto: PlanRequestDto)
    case deleteGoal(goalID: Int)
    case fetchGoal
    case fetchWeeklyGoal(Int, String)
    case fetchPlans(goalId: Int, date: String, range: Int)
    case achieveGoal(goalId: Int)
    case fetchSuccessRate(goalId: Int)
    case improvePlan(goalId: Int, planId: Int, planReqDto: PlanRequestDto)
}

extension GoalAPI: TargetType {
    var baseURL: URL {
        return URL(string: "\(SecretKey.baseUrl)/api/goals")!
    }
    
    var path: String {
        switch self {
        case .makeGoalWithPlan:
            return "/with-plan"
        case let .fetchWeeklyGoal(goalId, _):
            return "/\(goalId)/statistics/weekly"
        case let .fetchPlans(goalId, _, _):
            return "/\(goalId)/plans"
        case let .makePlan(goalId, _):
            return "/\(goalId)/plans"
        case let .achieveGoal(goalId):
            return "/\(goalId)/achieve"
        case let .fetchSuccessRate(goalId):
            return "/\(goalId)/statistics"
        case let .improvePlan(goalId, planId, _):
            return "/\(goalId)/plans/\(planId)/failure"
        case let .deleteGoal(goalID):
            return "/\(goalID)"
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .makeGoalWithPlan:
            return .post
        case .makePlan:
            return .post
        case .fetchGoal:
            return .get
        case .fetchWeeklyGoal:
            return .get
        case .fetchPlans:
            return .get
        case .achieveGoal:
            return .patch
        case .fetchSuccessRate:
            return .get
        case .improvePlan:
            return .post
        case .deleteGoal:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .makeGoalWithPlan(goalReqDto):
            return .requestJSONEncodable(goalReqDto)
        case let .fetchWeeklyGoal(_, date):
            return .requestParameters(parameters: ["date": date], encoding: URLEncoding.queryString)
        case let .fetchPlans(_, date, range):
            return .requestParameters(parameters: ["date": date, "range": range], encoding: URLEncoding.queryString)
        case let .makePlan(_, planReqDto):
            return .requestJSONEncodable(planReqDto)
        case let .improvePlan(_, _, planReqDto):
            return .requestJSONEncodable(planReqDto)
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
