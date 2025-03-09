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
            VStack {
                Text(store.goalTitle)
                    .headingStyle2()
                Text(store.planTitle)
                    .headingStyle2()
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


