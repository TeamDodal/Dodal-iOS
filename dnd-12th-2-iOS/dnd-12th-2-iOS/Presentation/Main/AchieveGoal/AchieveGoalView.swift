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
                Image("goalSuccess")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Image("partyBackground")
                        .resizable()
                        .scaledToFit()
                    Spacer()
                }
                .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading) {
                    Text("축하해요!\n목표 달성을 성공했어요.")
                        .font(.pretendard(size: 22, weight: .bold), lineHeight: 30)
                        .foregroundStyle(.gray900)
                        .padding(.top, 75)
                        .padding(.leading, 5)
                    
                    Spacer()
                    
                    if let goalInfo = store.goalInfo {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(goalInfo.title)
                                .font(.pretendard(size: 16, weight: .bold))
                                .foregroundStyle(.gray900)
                            
                            VStack(spacing: 12) {
                                HStack {
                                    Text("성공률")
                                        .font(.pretendard(size: 12, weight: .medium))
                                        .foregroundStyle(.gray)
                                    Spacer()
                                    Text("\(Int((CGFloat(goalInfo.successCount) / CGFloat(goalInfo.totalCount)) * 100))%")
                                        .font(.pretendard(size: 12, weight: .bold))
                                        .foregroundColor(.purple600)
                                }
                                CustomProgressView(progress: CGFloat(goalInfo.successCount) / CGFloat(goalInfo.totalCount))
                                    .frame(height: 12)
                            }
                            .padding(16)
                            .background(.white)
                            .cornerRadius(12)
                        }
                        .padding()
                        .background(.gray50)
                        .cornerRadius(12)
                    }
                    
                    HStack(spacing: 8) {
                        DDButton(title: "새로 목표 설정",
                                 font: .pretendard(size: 16, weight: .semibold),
                                 backgroundColor: .purple100,
                                 textColor: .purple500,
                                 height: 48,
                                 cornerRadius: 12) {
                            // action
                        }
                        DDButton(title: "완료",
                                 font: .pretendard(size: 16, weight: .semibold),
                                 backgroundColor: .purple500,
                                 textColor: .white,
                                 height: 48,
                                 cornerRadius: 12) {
                            // action
                        }
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 36)
                }
                .padding(20)
            }
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
                    .foregroundStyle(.gray)
                
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
//                                    AchieveGoal.State()) {
//        AchieveGoal()
//    })
//}
