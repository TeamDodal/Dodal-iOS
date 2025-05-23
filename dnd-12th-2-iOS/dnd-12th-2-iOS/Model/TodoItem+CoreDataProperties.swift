//
//  TodoItem+CoreDataProperties.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 5/12/25.
//
//

import Foundation
import CoreData


extension TodoItem {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoItem> {
        return NSFetchRequest<TodoItem>(entityName: "TodoItem")
    }
    
    @NSManaged public var content: String?
    @NSManaged public var dueDate: Date?
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var items: Set<TodoItem>?
    @NSManaged public var parent: TodoItem?
    
}

extension TodoItem : Identifiable {
    
}

extension TodoItem {
    var depth: Int {
        var count = 1
        var pointer = self.parent
        while pointer != nil {
            pointer = pointer?.parent
            count += 1
        }
        return count
    }
    
    var path: String {
        var path = self.title
        var pointer = self.parent
        while pointer != nil {
            path = "\(pointer?.title ?? "")/" + path
            pointer = pointer?.parent
        }
        return path
    }
}

extension TodoItem {
    func toDto() -> Todo {
        return Todo(
            id: self.id,
            title: self.title,
            content: self.content,
            dueDate: self.dueDate,
            children: (self.items ?? [])
                .sorted { ($0.dueDate ?? Date()) < ($1.dueDate ?? Date()) }
                .map { $0.toDto() },
            parentID: self.parent?.id,
            depth: self.depth,
            path: self.path
        )
    }
}
