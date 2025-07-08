//
//  OnboardingView.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 5/18/25.
//

import SwiftUI

import ComposableArchitecture
import Combine

struct OnboardingView: View {
    @Perception.Bindable fileprivate var store: StoreOf<OnboardingFeature>
    
    @FocusState private var isTitleFocused: Bool
    @FocusState private var focusedTaskIndex: Int?
    
    init(store: StoreOf<OnboardingFeature>) {
        self.store = store
    }
    
    var body: some View {
        WithPerceptionTracking {
            GeometryReader { geo in
                ScrollView {
                    VStack {
                        HStack {
                            if store.isLastStep {
                                Button(action: {
                                    store.send(.view(.backButtonTapped))
                                }) {
                                    Image(.iconBack)
                                        .foregroundStyle(.gray900)
                                }
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        Text(store.isLastStep ? "프로젝트 할 일 정하기" : "첫 번째 프로젝트 정하기")
                            .font(.pretendard(size: 24, weight: .bold))
                            .foregroundStyle(.gray900)
                            .padding(.top, 14)
                            .padding(.bottom, 61)
                        
                        VStack(spacing: 8) {
                            TextField(
                                "프로젝트 이름",
                                text: $store.title
                            )
                            .font(.pretendard(size: 22, weight: .medium))
                            .foregroundStyle(isTitleFocused ? .gray900 : (store.title.isEmpty ? .gray300 : .gray900))
                            .focused($isTitleFocused)
                            .frame(height: 64)
                            .padding(.horizontal, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(.gray0)
                            )
                            .padding(8)
                            .disabled(store.isLastStep)
                            
                            ForEach(store.tasks.indices, id: \.self) { index in
                                HStack(spacing: 12) {
                                    Image(.iconCheckPurple)
                                        .padding(.leading, 8)
                                    TextField(
                                        store.taskPlaceholders[index],
                                        text: $store.tasks[index]
                                    )
                                    .font(.pretendard(size: 16, weight: .medium))
                                    .foregroundStyle(
                                        (focusedTaskIndex == index) ? .gray900 : (store.tasks[index].isEmpty ? .gray300 : .gray900)
                                    )
                                    .focused($focusedTaskIndex, equals: index)
                                    .disabled(!store.isLastStep)
                                }
                                .padding(8)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.gray50)
                        )
                        .padding(.horizontal, 28)
                        
                        Spacer().frame(height: 70)
                        
                        Text("계획을 세운 사람의 42%가\n목표를 달성한다는 연구 결과가 있어요!")
                            .font(.pretendard(size: 12, weight: .medium))
                            .foregroundStyle(.gray500)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 20)
                    }
                    .frame(minHeight: geo.size.height)
                    .padding(.bottom, 36)
                    .navigationBarHidden(true)
                }
                .frame(width: geo.size.width)
                .scrollDisabled(true)
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .background(.gray0)
                .overlay(alignment: .bottom) {
                    DDButton(
                        type: .primary,
                        title: store.isLastStep ? "완료" : "다음"
                    ) {
                        store.send(
                            store.isLastStep
                            ? .view(.completeButtonTapped)
                            : .view(.nextButtonTapped)
                        )
                    }
                    .padding(.horizontal, 16)
                    .ignoresSafeArea(.keyboard)
                }
            }
            .keyboardAdaptive()
        }
    }
}
