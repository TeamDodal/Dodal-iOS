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
                        .tag(MainTabFeature.TabInfo.main)
                    
                    TodoView()
                        .tag(MainTabFeature.TabInfo.todo)
                    
                    SettingView()
                        .tag(MainTabFeature.TabInfo.setting)
                    
                }
                .overlay(alignment: .bottom) {
                    HStack {
                        ForEach(MainTabFeature.TabInfo.allCases, id: \.self) { tabInfo in
                            HStack {
                                HStack {
                                    Spacer()
                                    VStack {
                                        // TODO: 머지하고 이미지 추가예정
                                        Image("")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .background(.blue)
                                        Text(tabInfo.rawValue)
                                            .font(.pretendard(size: 10, weight: .regular))
                                            .foregroundStyle(store.currentTab == tabInfo ? .blue : .black)
                                    }
                                    Spacer()
                                }                                
                                .padding(.top, 12)
                                .padding(.bottom, 4)
                            }
                            
                        }
                    }
                    
                    .overlay(alignment: .top) {
                        Divider()
                    }
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
