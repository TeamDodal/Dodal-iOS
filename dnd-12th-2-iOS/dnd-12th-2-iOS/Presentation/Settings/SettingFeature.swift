//
//  SettingFeature.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 5/18/25.
//

import Foundation

import ComposableArchitecture

@Reducer
struct SettingFeature {
    @ObservableState
    struct State {
        var isShowWebView = false
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case showWebView
    }
        
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .showWebView:
                state.isShowWebView = true
                return .none
            default:
                return .none
            }
        }
    }
}
