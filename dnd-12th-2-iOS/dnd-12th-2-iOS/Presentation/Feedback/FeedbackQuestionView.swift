//
//  FeedbackQuestionView.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 3/13/25.
//

import SwiftUI
import ComposableArchitecture

struct FeedbackQuestionView: View {
    let store: StoreOf<FetchFeedback>
    var body: some View {
        VStack(spacing: 0) {
            FeedbackImage()
                .padding(.top, 20)
            FeedbackText()
                .padding(.top, 20)
            FeedbackSubText()
                .padding(.top, 8)
                        
            VStack(spacing: 12) {
                ForEach(store.feedbacks.first?.indicators ?? [], id: \.self) { title in
                    DDRow(title: title, isSelected: title == store.selectedText) {
                        store.send(.cellTapped(text: title))
                    }
                }
            }
            .padding(.top, 32)
            Spacer()
            DDButton(isDisable: store.buttonDisabled) {
                store.send(.completeButtonTapped)
            }
        }
        .navigationBar(left: {
            DDBackButton {
                store.send(.backButtonTapped)
            }
        })
        .onAppear {
            store.send(.loadFeedback)
        }
    }
}

extension FeedbackQuestionView {
    @ViewBuilder
    func FeedbackImage() -> some View {
        switch store.planInfo.completeType {
        case .success:
            Image("speaker")
        case .failure:
            Image("airplane")
        }
    }
    
    @ViewBuilder
    func FeedbackText() -> some View {
        switch store.planInfo.completeType {
        case .success:
            Text("다음에도 도달하기 위해 \n무엇을 시도해볼까요?")
                .headingStyle2()
                .foregroundStyle(.gray900)
        case .failure:
            Text("더 쉽게 도달하기 위해 \n무엇을 바꿔볼까요?")
                .headingStyle2()
                .foregroundStyle(.gray900)
        }
    }
    
    @ViewBuilder
    func FeedbackSubText() -> some View {
        switch store.planInfo.completeType {
        case .success:
            Text("아래에서 가장 시도하고 싶은 점 하나를 선택해주세요.")
                .bodyLargeMedium()
                .foregroundStyle(.gray600)
        case .failure:
            Text("아래에서 가장 개선하고 싶은 점 하나를 선택해주세요.")
                .bodyLargeMedium()
                .foregroundStyle(.gray600)
        }
    }
}

//#Preview {
//    FeedbackQuestionView()
//}
