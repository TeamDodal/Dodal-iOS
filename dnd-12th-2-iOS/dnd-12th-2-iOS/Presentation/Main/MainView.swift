//
//  MainView.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 3/5/25.
//

import SwiftUI
import ComposableArchitecture

struct MainView: View {
    @Perception.Bindable var store: StoreOf<MainNavigation>
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    var body: some View {
        WithPerceptionTracking {
            NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
                VStack(spacing: -36) {
                    HeaderView()
                    GoalList(store: store.scope(state: \.fetchGoal, action: \.fetchGoal))
                }
                .ignoresSafeArea(.all)
            } destination: { store in
                switch store.case {
                case let .home(store):
                    HomeView(store: store)
                case let .setGoal(store):
                    SetGoalFlowView(store: store)
                case let .myPage(store):
                    MyPageView(store: store)
                case let .goalResult(store):
                    GoalResultView(store: store)
                case let .achieveGoal(store):
                    AchieveGoalView(store: store)
                case let .feedbackComplete(store):
                    FeedbackCompleteView(store: store)
                case let .fetchFeedback(store):
                    FeedbackQuestionView(store: store)
                case let .feedbackResult(store):
                    FeedbackResultView(store: store)
                case let .improvePlan(store):
                    ImprovePlanView(store: store)
                case let .feedbackDetail(store):
                    FeedbackDetailView()
                }
            }
        }
    }
}

extension MainView {
    @ViewBuilder
    func HeaderView() -> some View {
            Image("backgroundImage")
            .resizable()
            .aspectRatio(contentMode: .fit)
        .overlay(alignment: .top, content: {
            VStack(spacing: 0) {
                HStack {
                    Image("appLogo")
                    Spacer()
                    Button(action: {
                        store.send(.goToMyPage)
                    }, label: {
                        Image("userImage")
                    })
                }
                .frame(height: 32)
                .padding(.top, safeAreaInsets.top)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 2) {
                        Text("오늘도")
                            .headingStyle3()
                            .foregroundStyle(Color.gray900)
                        HStack(spacing: 0) {
                            Text("도달")
                                .headingStyle3()
                                .foregroundStyle(Color.purple500)
                            Text("과")
                                .headingStyle3()
                                .foregroundStyle(Color.gray900)
                                .alignmentLeading()
                        }
                    }
                    .padding(.top, 17)
                    Text("함께 목표를 달성해봐요!")
                        .headingStyle3()
                        .foregroundStyle(Color.gray900)
                        .alignmentLeading()
                    
                    Button(action: {
                        store.send(.goToSetGoalView)
                    }, label: {
                        HStack(spacing: 4) {
                            Image("iconPlus")
                            
                            Text("목표 추가하기")
                                .bodyLargeSemibold()
                                .foregroundStyle(Color.white)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 9.5)
                    })
                    .background(Color.purple500)
                    .clipShape(Capsule())
                    .padding(.top, 16)
                }
            }
            .padding(.horizontal, 16)
        })
    }
}

//#Preview {
//    MainView()
//}
