//
//  MyPageView.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 2/28/25.
//

import SwiftUI
import ComposableArchitecture

struct MyPageView: View {
    @Perception.Bindable var store: StoreOf<MyPage>
    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                
                Text("이메일")
                    .bodyXLargeSemibold()
                    .alignmentLeading()
                    .foregroundStyle(.gray900)
                    .padding(.top, 40)
                Text(store.userInfo ?? "-")
                    .bodyMediumMedium()
                    .alignmentLeading()
                    .foregroundStyle(.gray900)
                    .padding(.top, 12)
                
                Button(action: {
                    store.send(.showWebView)
                }, label: {
                    Text("1:1 문의")
                        .bodyLargeSemibold()
                        .alignmentLeading()
                        .foregroundStyle(.gray900)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 12)
                })
                .background(.white)
                .cornerRadius(12)
                .padding(.top, 48)
                
                Button(action: {
                    store.send(.showLogoutAlert)
                }, label: {
                    Text("로그아웃")
                        .bodyLargeSemibold()
                        .alignmentLeading()
                        .foregroundStyle(.red)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 12)
                })
                .background(.white)
                .cornerRadius(12)
                .padding(.top, 16)
                
                Button(action: {
                    store.send(.showWithdrawAlert)
                }, label: {
                    Text("회원탈퇴")
                        .bodyLargeSemibold()
                        .alignmentLeading()
                        .foregroundStyle(.red)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 12)
                })
                .background(.white)
                .cornerRadius(12)
                .padding(.top, 16)
                
                Spacer()
            }
            .navigationBar(center: {
                Text("마이페이지")
                    .bodyLargeBold()
                    .foregroundStyle(.gray800)
            }, left: {
                DDBackButton(action: {
                    store.send(.backButtonTapped)
                })
            })
            .background(.gray50)
            .overlay(alignment: .center, content: {
                if store.isShowLogoutAlert {
                    DDAlert(
                        title: "로그아웃 하시겠습니까?",
                        cancelButtonTitle: "취소",
                        confirmButtonTitle: "확인",
                        onCancel: {
                            store.send(.hideLogoutAlert)
                        },
                        onConfirm: {
                            store.send(.logoutButtonTapped)
                        }
                    )
                }
            })
            .overlay(alignment: .center, content: {
                if store.isShowWithdrawAlert {
                    DDAlert(
                        title: "회원탈퇴 하시겠습니까?",
                        cancelButtonTitle: "취소",
                        confirmButtonTitle: "확인",
                        onCancel: {
                            store.send(.hideWithdrawAlert)
                        },
                        onConfirm: {
                            store.send(.withdrawButtonTapped)
                        }
                    )
                }
            })
            .sheet(isPresented: $store.isShowWebView) {
                WebView(url: "https://www.instagram.com/dodal_in_ur_goal?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw==")
                    .padding(.top, 40)
            }
        }
    }
}

//#Preview {
//    MyPageView()
//}
