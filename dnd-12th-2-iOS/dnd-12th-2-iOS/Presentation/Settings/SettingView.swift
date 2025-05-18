//
//  SettingView.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 5/6/25.
//

import SwiftUI

import ComposableArchitecture

struct SettingView: View {
    @Perception.Bindable var store: StoreOf<SettingFeature>
    
    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                HStack {
                    Text("설정")
                        .font(.pretendard(size: 16, weight: .bold))
                        .foregroundStyle(.gray900)
                }
                .padding(.top, 16)
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
                
                Button(action: {
                    store.send(.showWebView)
                }) {
                    Text("1:1 문의")
                        .font(.pretendard(size: 16, weight: .semibold))
                        .foregroundStyle(.gray900)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray0)
                        )
                        .padding(.horizontal, 16)
                        .padding(.top, 38)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray50)
            .sheet(isPresented: $store.isShowWebView) {
                WebView(url: "https://www.instagram.com/dodal_in_ur_goal?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw==")
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}
