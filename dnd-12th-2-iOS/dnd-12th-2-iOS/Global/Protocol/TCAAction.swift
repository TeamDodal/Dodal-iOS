//
//  TCAAction.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 5/12/25.
//

protocol TCAAction {
    associatedtype ViewAction
    associatedtype ExternalAction
    associatedtype DestinationAction
    
    static func view(_:ViewAction) -> Self
    static func external(_:ExternalAction) -> Self
    static func destination(_: DestinationAction) -> Self
}
