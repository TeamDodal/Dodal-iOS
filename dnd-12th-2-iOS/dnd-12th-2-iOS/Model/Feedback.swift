//
//  Feedback.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 3/12/25.
//

import Foundation

struct Feedback: Codable, Hashable {
    let question: String
    let description: String
    let order: Int
    let indicators: [String]
}
