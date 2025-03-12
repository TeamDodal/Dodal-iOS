//
//  GoalList.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 3/6/25.
//

import SwiftUI
import ComposableArchitecture

struct GoalList: View {
    let store: StoreOf<FetchGoal>
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Text("진행중인 목표")
                    .bodyXLargeBold()
                    .foregroundStyle(Color.gray900)
                Text("\(store.goalList.count)")
                    .bodyXLargeBold()
                    .foregroundStyle(Color.purple500)
                    .padding(.leading, 8)
                Spacer()
            }
            .padding(.top, 24)
            .padding(.bottom, 16)
            .padding(.horizontal, 16)
            if !store.goalList.isEmpty {
                VStack(spacing: 0) {
                    Image("plusIcon")
                        .onTapGesture {
                            store.send(.goToSetGoal)
                        }
                    Text("새로운 목표를 설정해주세요")
                        .bodyLargeSemibold()
                        .alignmentCenter()
                        .foregroundStyle(.gray700)
                        .padding(.top, 12)
                    Text("아직 목표가 생성되지 않았어요. \n '+ 목표 추가하기' 버튼을 눌러 목표를 설정해주세요.")
                        .bodySmallRegular()
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.gray500)
                        .padding(.top, 6)
                }
                .padding(.vertical, 16)
                .background(.white)
                .cornerRadius(12)
                .padding(.horizontal, 16)
                Spacer()
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 16) {
                        ForEach(store.goalList, id: \.self) { item in
                            GoalListCell(goal: item) { store.send(.cellTapped(item)) }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
        .background(.gray50)
        .clipShape(.rect(topLeadingRadius: 20, topTrailingRadius: 20))
        .onAppear {
            store.send(.fetchGoals)
        }
    }
}

//#Preview {
//    GoalList()
//}
