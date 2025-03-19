//
//  FeedbackResultView.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 3/13/25.
//

import SwiftUI
import ComposableArchitecture

struct FeedbackResultView: View {
    let store: StoreOf<FeedbackResult>
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    var body: some View {
        VStack {
            ImageBackground()
            FeedbackReslt()
            Spacer()
            ResultButton()
        }
        .ignoresSafeArea(.container, edges: .top)
        .navigationBarHidden(true)
        .onAppear {
            store.send(.fetchCompletePlan)
        }
    }
}

extension FeedbackResultView {
    @ViewBuilder
    func ImageBackground() -> some View {
        switch store.planInfo.completeType {
        case .success:
            VStack {
                HStack(spacing: 8) {
                    Image("successBadge")
                    VStack {
                        Text("앞으로의 \n한 걸음도 기대할게요.")
                            .headingStyle3()
                    }
                    Spacer()
                }
                .padding(.top, safeAreaInsets.top + 48)
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
                .padding(.bottom, 20)
            }
            .frame(maxWidth: .infinity)
            .background(Color.success.overlay(alignment: .top, content: {
                Image("feedbackBackground")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }))
            
        case .failure:
            VStack {
                HStack(spacing: 8) {
                    Image("target")
                    VStack {
                        Text("다음에는 지금보다 \n훨씬 더 수월할 거예요.")
                            .headingStyle3()
                    }
                    Spacer()
                }
                .padding(.top, safeAreaInsets.top + 48)
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
                .padding(.bottom, 20)
            }
            .frame(maxWidth: .infinity)
            .background(Color.failure)
        }
    }
    
    @ViewBuilder
    func FeedbackReslt() -> some View {
        VStack {
            VStack(spacing: 0) {
                Text("나의 계획")
                    .bodyLargeBold()
                    .alignmentLeading()
                    .foregroundStyle(.gray900)
                    .padding(.top, 24)
                
                CompleteList(result: store.resultPlan)
                    .padding(.top, 12)
                
                Text("다음에는 이렇게 도달할까요?")
                    .bodyLargeBold()
                    .alignmentLeading()
                    .foregroundStyle(.gray900)
                    .padding(.top, 24)
                
                HStack(spacing: 8) {
                    Image("iconCheckSmall")
                    Text(store.planInfo.indicators)
                        .font(.pretendard(size: 14, weight: .semibold))
                        .foregroundStyle(Color.gray800)
                    Spacer()
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 12)
                .background(Color.purple50)
                .cornerRadius(8)
                .padding(.top, 12)
                
            }
            .padding(.horizontal, 16)
            Spacer()
        }
        .background(.white)
        .cornerRadius(20)
        .offset(y: -20)
    }
    
    @ViewBuilder
    func ResultButton() -> some View {
        VStack {
            switch store.planInfo.completeType {
            case .success:
                DDButton(title: "확인") {
                    store.send(.completeButtonTapped)
                }
            case .failure:
                DDButton(title: "계획 재설정하기") {
                    store.send(.improveButtonTapped)
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

//#Preview {
//    FeedbackResultView()
//}
