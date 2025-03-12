//
//  GoalResultView.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 3/9/25.
//

import SwiftUI
import ComposableArchitecture

struct GoalResultView: View {
    let store: StoreOf<GoalResult>
    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                Text("목표와 할 일을 \n생성했어요")
                    .headingStyle1()
                    .alignmentLeading()
                    .foregroundStyle(.gray900)
                    .padding(.top, 40)
                Text("작은 일을 하나씩 완료하며 목표로 나아가요")
                    .bodyLargeMedium()
                    .alignmentLeading()
                    .foregroundStyle(.gray800)
                    .padding(.top, 8)
                
                Text("목표")
                    .bodyXLargeSemibold()
                    .alignmentLeading()
                    .foregroundStyle(.gray900)
                    .padding(.top, 48)
                HStack {
                    Text(store.goalTitle)
                        .bodyMediumMedium()
                        .foregroundStyle(.purple900)
                        .padding(12)
                        .background(.purple50)
                        .cornerRadius(8)
                        .padding(.top, 4)
                    Spacer()
                }
                
                Text("할 일")
                    .bodyXLargeSemibold()
                    .alignmentLeading()
                    .foregroundStyle(.gray900)
                    .padding(.top, 20)
                HStack {
                    Text(store.planTitle)
                        .bodyMediumMedium()
                        .foregroundStyle(.purple900)
                        .padding(12)
                        .background(.purple50)
                        .cornerRadius(8)
                        .padding(.top, 4)
                    Spacer()
                }
                
                Text("시간")
                    .bodyXLargeSemibold()
                    .alignmentLeading()
                    .foregroundStyle(.gray900)
                    .padding(.top, 20)
                HStack {
                    Text(store.dateString)
                        .bodyMediumMedium()
                        .foregroundStyle(.purple900)
                        .padding(12)
                        .background(.purple50)
                        .cornerRadius(8)
                        .padding(.top, 4)
                    Spacer()
                }
                
                Spacer()
                
                DDButton(title: "시작하기") {
                    store.send(.goToMain)
                }
            }
            .navigationBar(left: {
                EmptyView()
            })
        }
    }
}


