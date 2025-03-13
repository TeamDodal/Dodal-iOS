//
//  PlanMapper.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 3/8/25.
//

extension PlanInfo {
    func toDto() -> PlanRequestDto {
        .init(title: title,
              startDate: startDate.toISO8601DateFormat(),
              endDate: endDate.toISO8601DateFormat())
    }
}

extension Array where Element == PlanCompleteResDto {
    func toDomain() -> [ResultPlan] {
        self.map { .init(planId: $0.planId,
                         title: $0.title,
                         status: $0.status,
                         guide: $0.guide,
                         completedDate: $0.completedDate)}
    }
}

extension PlanCompleteResDto {
    func toDomain() -> ResultPlan {
        .init(planId: planId,
              title: title,
              status: status,
              guide: guide,
              completedDate: completedDate)
    }
}
