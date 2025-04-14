//
//  AchieveGoalView.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 3/8/25.
//

import SwiftUI

import ComposableArchitecture

struct AchieveGoalView: View {
    @Perception.Bindable var store: StoreOf<AchieveGoal>
    @State private var progress: CGFloat = 0.75
    
    var body: some View {
        WithPerceptionTracking {
            ZStack {
                
                VStack(alignment: .leading) {
                    Text("축하해요!\n목표 달성을 성공했어요.")
                        .font(.pretendard(size: 28, weight: .bold), lineHeight: 40)
                        .foregroundStyle(.gray900)
                        .padding(.top, 113)
                        .padding(.leading, 5)
                    
                    Spacer()
                    
                    if let goalInfo = store.goalInfo {
                        VStack(alignment: .leading, spacing: 20) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("목표")
                                    .font(.pretendard(size: 14, weight: .medium))
                                    .foregroundStyle(.gray500)
                                Text(goalInfo.title)
                                    .font(.pretendard(size: 16, weight: .semibold))
                                    .foregroundStyle(.gray900)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text("계획 달성률")
                                        .font(.pretendard(size: 14, weight: .medium))
                                        .foregroundStyle(.gray500)
                                    Spacer()
                                    Text("\(goalInfo.totalCount > 0 ? Int((CGFloat(goalInfo.successCount) / CGFloat(goalInfo.totalCount)) * 100) : 0)%")
                                        .font(.pretendard(size: 16, weight: .semibold))
                                        .foregroundColor(.purple600)
                                }
                                CustomProgressView(progress: goalInfo.totalCount > 0 ? CGFloat(goalInfo.successCount) / CGFloat(goalInfo.totalCount) : 0)
                                    .frame(height: 12)
                            }
                            .cornerRadius(12)
                        }
                        .padding(24)
                        .background(.white)
                        .cornerRadius(12)
                    }
                    
                    HStack(spacing: 8) {
                        DDButton(title: "새 목표 설정",
                                 font: .pretendard(size: 16, weight: .medium),
                                 backgroundColor: .purple50,
                                 textColor: .purple500,
                                 cornerRadius: 12) {
                            store.send(.goToSetGoal)
                        }
                        DDButton(title: "완료",
                                 font: .pretendard(size: 16, weight: .medium),
                                 backgroundColor: .purple500,
                                 textColor: .white,
                                 cornerRadius: 12) {
                            store.send(.goToHome)
                        }
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 16)
                }
                .padding(20)
                
            }
            .ignoresSafeArea(.all)
            .background(alignment: .top) {
                Image("partyBackground")
                    .resizable()
                    .scaledToFit()
            }
            .background(
                Image("goalSuccess")
                    .resizable()
                    .scaledToFill()
            )
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            store.send(.loadGoalInfo)
        }
    }
}

struct CustomProgressView: View {
    let progress: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundStyle(.purple100)
                
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: min(progress * geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundStyle(.purple600)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

//#Preview {
//    AchieveGoalView(store: Store(initialState:
//                                    AchieveGoal.State(goalId: 1)) {
//        AchieveGoal()
//    })
//}
