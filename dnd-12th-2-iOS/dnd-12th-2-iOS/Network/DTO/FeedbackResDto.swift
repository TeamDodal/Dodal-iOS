//
//  FeedbackResDto.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 3/12/25.
//

import Foundation

struct FeedbackResDto: Decodable {
    let elements: [FeedbackData]
}

struct FeedbackData: Decodable {
    let question: String
    let description: String
    let order: Int
    let indicators: [String]
}

extension Array where Element == FeedbackData {
    func toDomain() -> [Feedback] {
        self.map { Feedback(question: $0.question,
                            description: $0.description,
                            order: $0.order,
                            indicators: $0.indicators)}
    }
}
