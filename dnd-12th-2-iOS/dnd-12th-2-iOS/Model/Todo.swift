//
//  Todo.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 5/20/25.
//

import Foundation

struct Todo: Identifiable, Equatable, Hashable {
    let id: UUID
    var title: String
    var content: String?
    var dueDate: Date?
    let createDate: Date
    let updateDate: Date
    var children: [Todo] = []
    var parentID: UUID?
    var depth: Int
    var isCompleted: Bool = false
    var path: [String]
}
