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
