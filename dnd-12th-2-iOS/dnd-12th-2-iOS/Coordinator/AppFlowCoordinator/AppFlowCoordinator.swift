//
//  AppFlowCoordinator.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 5/6/25.
//

import ComposableArchitecture

@Reducer
struct AppFlowCoordinator {
    @ObservableState
    enum State {
        case mainTab(MainTabFeature.State)
        case onboarding(OnboardingFeature.State)
        
        init(launchClient: LaunchClient = .liveValue) {
            if launchClient.isFirstLaunch() {
                self = .onboarding(.init())
            } else {
                self = .mainTab(.init())
            }
        }
    }
    
    enum Action {
        case mainTab(MainTabFeature.Action)
        case onboarding(OnboardingFeature.Action)
        case showMainTab
        case showOnboarding
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .showMainTab:
                state = .mainTab(.init())
                return .none
            case .showOnboarding:
                state = .onboarding(.init())
                return .none
            case .onboarding(.external(.onboardingCompleted)):
                return .send(.showMainTab)
            default:
                return .none
            }
        }
        .ifCaseLet(\.mainTab, action: \.mainTab) {
            MainTabFeature()
        }
        .ifCaseLet(\.onboarding, action: \.onboarding) {
            OnboardingFeature()
        }
    }
}
