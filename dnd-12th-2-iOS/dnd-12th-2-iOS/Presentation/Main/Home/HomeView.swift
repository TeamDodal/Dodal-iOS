//
//  HomeView.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 2/28/25.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {
    @Perception.Bindable var store: StoreOf<HomeNavigation>
    @State var isScrolling = false
    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                CalendarView(store: store.scope(state: \.calendar,
                                                action: \.calendar))
                PlanListVIew(isScrolling: $isScrolling,
                             store: store.scope(state: \.fetchPlan,
                                                action: \.fetchPlan))
                .padding(.horizontal, -16)
                .background(Color.customBackground)
            }
            .navigationBar(center: {
                HomeNavigation()
            })
            .overlay(alignment: .center, content: {
                if store.state.isCustomAlertPresented {
                    DDAlert(
                        title: "목표를 정말 달성했나요?",
                        cancelButtonTitle: "취소",
                        confirmButtonTitle: "확인",
                        onCancel: {
                            store.send(.customAlertDismissed)
                        },
                        onConfirm: {
                            // 목표 달성 시 액션
                            store.send(.customAlertDismissed)
                        }
                    )
                }
            })
            .overlay(alignment: .bottomTrailing, content: {
                CTAButton(isScrolling: isScrolling) {
                    store.send(.addPlanButtonTapped)
                }
                .offset(y: -10)
                .padding(.horizontal, 16)
            })
            .bottomSheet($store.isShowMenu) {
                VStack {
                    MenuItem()
                }
            }
        }
    }
}

extension HomeView {
    private func HomeNavigation() -> some View {
        HStack {
            DDBackButton(action: {
                store.send(.backButtonTapped)
            })
            Spacer()
            
            Text(store.goalTitle)
                .bodyLargeSemibold()
                .foregroundStyle(Color.gray900)
                .lineLimit(1)
            
            Spacer()
            
            Button(action: {
                store.send(.showMenu)
            }, label: {
                Image("menuIcon")
            })
        }
    }
    
    private func MenuItem() -> some View {
        VStack(spacing: 8) {
            HStack {
                HStack(spacing: 12) {
                    Image("goalIcon")
                    VStack {
                        Text("도달")
                            .bodyMediumSemibold()
                            .alignmentLeading()
                            .foregroundStyle(Color.gray900)
                        Text("목표를 완수하고 새 목표를 설정합니다.")
                            .bodySmallRegular()
                            .alignmentLeading()
                            .foregroundStyle(Color.gray500)
                    }
                    
                    Spacer()
                    Image("iconGray")
                }
                .onTapGesture {
                    store.send(.showAlert)
                }
            }
            .padding(.vertical, 14.5)
            .padding(.horizontal, 12)
            
            HStack {
                HStack(spacing: 12) {
                    Image("trashIcon")
                    VStack {
                        Text("삭제")
                            .bodyMediumSemibold()
                            .alignmentLeading()
                            .foregroundStyle(Color.gray900)
                        Text("목표를 삭제합니다.")
                            .bodySmallRegular()
                            .alignmentLeading()
                            .foregroundStyle(Color.gray500)
                    }
                    Spacer()
                    Image("iconGray")
                }
            }
            .padding(.vertical, 14.5)
            .padding(.horizontal, 12)
        }
    }
}

//#Preview {
//    HomeView()
//}
