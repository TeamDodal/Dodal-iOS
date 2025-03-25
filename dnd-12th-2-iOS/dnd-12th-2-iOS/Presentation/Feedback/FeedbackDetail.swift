//
//  FeedbackDetail.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 3/25/25.
//

import ComposableArchitecture

@Reducer
struct FeedbackDetail {
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
