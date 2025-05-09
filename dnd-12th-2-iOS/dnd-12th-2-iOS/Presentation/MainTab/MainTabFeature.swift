//
//  MainTabFeature.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 5/6/25.
//

import ComposableArchitecture

@Reducer
struct MainTabFeature {
    
    enum TabInfo: String, CaseIterable {
        case main = "홈"
        case todo = "할일"
        case setting = "설정"
    }
    
    @ObservableState
    struct State {
        var currentTab: TabInfo = .main
        var mainFlow = MainFlowCoordinator.State()
    }
    
    enum Action: BindableAction {
        // tab 선택
        case selectedTab(TabInfo)
        case binding(BindingAction<State>)
        case mainFlow(MainFlowCoordinator.Action)
    }
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Scope(state: \.mainFlow, action: \.mainFlow) {
            MainFlowCoordinator()
        }
        Reduce { state, action in
            switch action {
            case let .selectedTab(tab):
                state.currentTab = tab
                return .none
            default:
                return .none
            }
        }
    }
}
