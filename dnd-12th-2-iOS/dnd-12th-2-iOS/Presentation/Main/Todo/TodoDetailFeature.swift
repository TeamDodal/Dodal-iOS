//
//  TodoDetailFeature.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 5/12/25.
//

import Foundation

import ComposableArchitecture

@Reducer
struct TodoDetailFeature {
    @ObservableState
    struct State {}
    
    enum Action {}
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
    }
}
