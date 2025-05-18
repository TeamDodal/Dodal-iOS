//
//  OnboardingView.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 5/18/25.
//

import SwiftUI

struct OnboardingView: View {
    @State var title = ""
    @State private var tasks: [String] = [
        "가장 먼저 할 일",
        "다음으로 할 일",
        "그 다음으로 할 일",
        "그 다음으로 할 일",
        "그 다음으로 할 일"
    ]
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    // 뒤로가기 액션
                }) {
                    Image(.iconBack)
                        .foregroundStyle(.gray900)
                }
                Spacer()
            }
            .padding(.horizontal)
            Text("첫 번째 프로젝트 정하기")
                .font(.pretendard(size: 24, weight: .bold))
                .foregroundStyle(.gray900)
                .padding(.top, 14)
                .padding(.bottom, 61)
            VStack(spacing: 8) {
                TextField("프로젝트 이름", text: $title)
                    .font(.pretendard(size: 22, weight: .medium))
                    .foregroundStyle(.gray300)
                    .frame(height: 64)
                    .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(.gray0)
                    )
                    .padding(8)
                ForEach(tasks.indices, id: \.self) { index in
                    HStack(spacing: 12) {
                        Image(.iconCheckPurple)
                            .padding(.leading, 8)
                        TextField("할 일 입력", text: $tasks[index])
                            .font(.pretendard(size: 16, weight: .medium))
                            .foregroundStyle(.gray300)
                    }
                    .padding(8)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.gray50)
            )
            .padding(.horizontal, 28)
            Spacer()
            Text("계획을 세운 사람의 42%가\n목표를 달성한다는 연구 결과가 있어요!")
                .font(.pretendard(size: 12, weight: .medium))
                .foregroundStyle(.gray500)
                .multilineTextAlignment(.center)
                .padding(.bottom, 20)
            DDButton(type: .primary, title: "다음") {
                // 버튼 액션
            }
            .padding(.horizontal, 16)
        }
        .navigationBarHidden(true)
        .padding(.bottom, 36)
        .background(.gray0)
    }
}

#Preview {
    OnboardingView()
}
