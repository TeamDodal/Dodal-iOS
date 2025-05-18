//
//  TodoItem+CoreDataClass.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 5/12/25.
//
//

import Foundation
import CoreData

@objc(TodoItem)
public class TodoItem: NSManagedObject {
    
}
extension TodoItem {
    @objc(addItemsObject:)
    @NSManaged func addToItems(_ value: TodoItem)

    @objc(removeItemsObject:)
    @NSManaged func removeFromItems(_ value: TodoItem)

    @objc(addItems:)
    @NSManaged func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged func removeFromItems(_ values: NSSet)    
}
