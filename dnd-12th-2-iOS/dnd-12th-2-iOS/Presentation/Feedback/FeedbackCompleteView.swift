//
//  FeedbackCompleteView.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 3/13/25.
//

import SwiftUI
import ComposableArchitecture

struct FeedbackCompleteView: View {
    let store: StoreOf<FeedbackComplete>
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    var body: some View {
                VStack {
                    ResultText()
                    FeedbackResult()
                    Spacer()
                    DDButton(action: {
                        store.send(.nextButtonTapped)
                    })
                }
                .navigationBar(left: {
                    DDBackButton(action: {
                        store.send(.backButtonTapped)
                    })
                })
                .background(BackgroundImage())
        }
}

extension FeedbackCompleteView {
    @ViewBuilder
    func ResultText() -> some View {
        switch store.planInfo.completeType {
        case .success:
            Text("계획을 달성했어요! \n한걸음 더 성장한 당신을 응원해요.")
                .headingStyle2()
                .alignmentLeading()
                .foregroundStyle(.gray900)
                .padding(.top, 20)
        case .failure:
            Text("아쉬운 마무리지만, \n다음 걸음을 위한 과정일 뿐이에요.")
                .headingStyle2()
                .alignmentLeading()
                .foregroundStyle(.gray900)
                .padding(.top, 20)
        }
    }
    
    @ViewBuilder
    func FeedbackResult() -> some View {
        switch store.planInfo.completeType {
        case .success:
            HStack(spacing: 12) {
             Circle()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(.white)
                    .overlay {
                        Image("iconComplete")
                    }
            VStack {
                Text("나의 계획")
                    .bodySmallMedium()
                    .alignmentLeading()
                    .foregroundStyle(.gray700)
                
                Text(store.planInfo.title)
                    .bodyMediumSemibold()
                    .alignmentLeading()
                    .foregroundStyle(.gray900)
            }
            }
            .padding(16)
            .background(.gray50)
            .cornerRadius(12)
            .padding(.top, 32)
        case .failure:
            HStack(spacing: 12) {
             Circle()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(.white)
                    .overlay {
                        Image("failureIcon")
                    }
            VStack {
                Text("나의 계획")
                    .bodySmallMedium()
                    .alignmentLeading()
                    .foregroundStyle(.gray700)
                
                Text(store.planInfo.title)
                    .bodyMediumSemibold()
                    .alignmentLeading()
                    .foregroundStyle(.gray900)
            }
            }
            .padding(16)
            .background(.gray50)
            .cornerRadius(12)
            .padding(.top, 32)
        }
    }
    
    @ViewBuilder
    func BackgroundImage() -> some View {
        switch store.planInfo.completeType {
        case .success:
            VStack {
                Image("feedbackBackground")
                    .offset(y: -safeAreaInsets.top)
                Spacer()
                Image("stairSuccess")
                    .offset(y: safeAreaInsets.bottom)
            }
        case .failure:
            VStack {
                Spacer()
                Image("stairSuccess")
                    .offset(y: safeAreaInsets.bottom)
            }
        }
    }
}

//#Preview {
//    FeedbackCompleteView()
//}
