//
//  PlanCompleteResDto.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 3/13/25.
//

struct PlanCompleteResDto: Decodable {
    let planId: Int
    let title: String
    let status: String
    let guide: String
    let completedDate: String
    let startDate: String
    let endDate: String
}
