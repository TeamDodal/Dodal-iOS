//
//  FeedbackResult.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 3/13/25.
//
import ComposableArchitecture

@Reducer
struct FeedbackResult {
    @ObservableState
    struct State {
        let planInfo: Plan
        init(planInfo: Plan) {
            self.planInfo = planInfo
        }
    }
        
    enum Action {
        
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {            
            default:
                return .none
            }
        }
    }
}
