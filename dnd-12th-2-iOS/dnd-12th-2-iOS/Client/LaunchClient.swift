//
//  LaunchClient.swift
//  dnd-12th-2-iOS
//
//  Created by 박우연 on 6/20/25.
//

import Foundation

import ComposableArchitecture

struct LaunchClient {
    var isFirstLaunch: () -> Bool
    
    static let storage = TodoStorage.shared
}

extension LaunchClient: DependencyKey {
    static let liveValue = Self (
        isFirstLaunch: {
            do {
                return try storage.fetchTodoItems().isEmpty
            } catch {
                return true
            }
        }
    )
}

extension DependencyValues {
    var launchClient: LaunchClient {
        get { self[LaunchClient.self] }
        set { self[LaunchClient.self] = newValue }
    }
}
