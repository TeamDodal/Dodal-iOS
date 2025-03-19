//
//  MyPage.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 2/28/25.
//

import ComposableArchitecture

@Reducer
struct MyPage {
    @ObservableState
    struct State {
        var isShowLogoutAlert = false
        var isShowWithdrawAlert = false
        var isShowWebView = false
        var userInfo: String? {
            KeyChainManager.readItem(key: .userInfo)
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case showWebView
        case showWithdrawAlert
        case hideWithdrawAlert
        case showLogoutAlert
        case hideLogoutAlert
        case logoutButtonTapped
        case logoutComplete
        case backButtonTapped
        case withdrawButtonTapped
        case withdrawComplete
    }
    
    @Dependency(\.authClient) var authClient
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .showWebView:
                state.isShowWebView = true
                return .none
            case .showWithdrawAlert:
                state.isShowWithdrawAlert = true
                return .none
            case .hideWithdrawAlert:
                state.isShowWithdrawAlert = false
                return .none
            case .showLogoutAlert:
                state.isShowLogoutAlert = true
                return .none
            case .hideLogoutAlert:
                state.isShowLogoutAlert = false
                return .none
            case .logoutButtonTapped:
                return .run { send in
                    try await authClient.signOut()                    
                    await send(.logoutComplete)
                }
            case .logoutComplete:
                KeyChainManager.deleteItem(key: .userInfo)
                KeyChainManager.deleteItem(key: .accessToken)
                KeyChainManager.deleteItem(key: .refreshToken)
                return .none
            case .withdrawButtonTapped:
                return .run { send in
                    try await authClient.withdraw()
                    await send(.withdrawComplete)
                }
            case .withdrawComplete:
                KeyChainManager.deleteItem(key: .userInfo)
                KeyChainManager.deleteItem(key: .accessToken)
                KeyChainManager.deleteItem(key: .refreshToken)
                return .none
            default:
                return .none
            }
        }
    }
}

