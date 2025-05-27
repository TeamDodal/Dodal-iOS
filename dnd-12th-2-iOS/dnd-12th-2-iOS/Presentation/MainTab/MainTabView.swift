//
//  MainTabView.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 5/6/25.
//

import SwiftUI

import ComposableArchitecture

struct MainTabView: View {
    
    @Perception.Bindable var store: StoreOf<MainTabFeature>
    
    var body: some View {
        WithPerceptionTracking {
            NavigationStack {
                TabView(selection: $store.currentTab) {
                    MainFlowCoordinatorView(store: store.scope(state: \.mainFlow, action: \.mainFlow))
                        .tag(TabInfo.main)
                    
//                    TodoView()
//                        .tag(TabInfo.todo)
                    
                    SettingView(store: .init(initialState: SettingFeature.State(), reducer: {
                        SettingFeature()
                    }))
                        .tag(TabInfo.setting)
                    
                }
                .overlay(alignment: .bottom) {
                    TabBarView(currentTab: store.currentTab)
                }
            }
        }
    }
}

#Preview {
    MainTabView(store: .init(initialState: MainTabFeature.State(), reducer: {
        MainTabFeature()
    }))
}
