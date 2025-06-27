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
    var depth: Int = 0
    var isCompleted: Bool = false
    var path: [String] = []
    
    init(id: UUID,
         title: String,
         content: String? = nil,
         dueDate: Date? = nil,
         createDate: Date,
         updateDate: Date,
         children: [Todo] = [],
         parentID: UUID? = nil,
         depth: Int,
         isCompleted: Bool = false,
         path: [String]) {
        self.id = id
        self.title = title
        self.content = content
        self.dueDate = dueDate
        self.createDate = createDate
        self.updateDate = updateDate
        self.children = children
        self.parentID = parentID
        self.depth = depth
        self.isCompleted = isCompleted
        self.path = path
    }
    
    init(title: String, content: String? = nil, dueDate: Date? = nil) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.dueDate = dueDate
        self.createDate = Date()
        self.updateDate = Date()        
    }
    
    init(id: UUID, title: String, content: String? = nil, dueDate: Date? = nil) {
        self.id = id
        self.title = title
        self.content = content
        self.dueDate = dueDate
        self.createDate = Date()
        self.updateDate = Date()
    }
}

