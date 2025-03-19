//
//  ImprovePlanView.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 3/14/25.
//

import SwiftUI

import ComposableArchitecture

struct ImprovePlanView: View {
    @Perception.Bindable var store: StoreOf<ImprovePlan>
    @FocusState var planFieldFocus: Bool
    
    var body: some View {
        WithPerceptionTracking {
            ScrollView {
                VStack(spacing: 0) {
                    DDResultRow(planInfo: store.planInfo) { }.disabled(true)
                    TipView(store: store.scope(state: \.fetchTip, action: \.fetchTip))
                        .padding(.top, 4)
                    
                    Text("할 일")
                        .font(.pretendard(size: 18, weight: .semibold))
                        .alignmentLeading()
                        .foregroundStyle(Color.gray900)
                        .padding(.top, 27)
                    DDRoundTextFiled(text: $store.planTitle, isFocused: $planFieldFocus)
                        .padding(.top, 4)
                    DateGroup()
                        .padding(.top, 32)
                    Spacer()
                    DDButton(title: "확인", isDisable: store.buttonDisabled){
                        store.send(.completeButtonTapped)
                    }
                    .padding(.top, 38)
                    .padding(.bottom, 26)
                }
                .padding(.top, 24)
                .onTapGesture {
                    UIApplication.shared.hideKeyboard()
                }
                .onAppear {
                    planFieldFocus = true
                }
            }
            .scrollDisabled(true)
            .ignoresSafeArea(.keyboard)
            .navigationBar(
                center: { Text("할 일 개선")
                        .font(.pretendard(size: 16, weight: .bold))
                    .foregroundStyle(.gray900)
            }, left: { DDBackButton(action: {
                    store.send(.backButtonTapped)
                })}, right: { Button(action: {
                    store.send(.deletePlanRequest)
            }) {
                Text("삭제")
                    .font(.pretendard(size: 14, weight: .medium))
                    .foregroundStyle(.purple700)
            } })
        }
    }
}

extension ImprovePlanView {
    @ViewBuilder
    func DateGroup() -> some View {
        VStack(spacing: 0) {
            Text("시간")
                .bodyXLargeSemibold()
                .foregroundStyle(Color.gray900)
                .alignmentLeading()
            Text(store.resultTimeStr)
                .bodyMediumMedium()
                .alignmentLeading()
                .foregroundStyle(store.timePickerValidate ? Color.gray500 : Color.red)
                .padding(.top, 8)
            Divider()
                .padding(.top, 8)
            HStack {
                Text("시작 시각")
                    .bodyMediumMedium()
                    .foregroundStyle(Color.gray600)
                Spacer()
                Text(store.startDateResultStr)
                    .bodyMediumMedium()
                    .foregroundStyle(Color.purple800)
                Image("iconUp")
                    .rotationEffect(.degrees(store.isShowStartPicker ? 0 : 180))
            }
            .onTapGesture {
                store.send(.startPickerTapped)
            }
            .padding(.top, 16)
            if store.isShowStartPicker {
                DDatePicker(date: $store.startDate)
                    .padding(.top, 8)
                    .animation(.easeInOut, value: store.isShowStartPicker)
            }
            HStack {
                Text("종료 시각")
                    .bodyMediumMedium()
                    .foregroundStyle(Color.gray600)
                Spacer()
                Text(store.endDateResultStr)
                    .bodyMediumMedium()
                    .foregroundStyle(Color.purple800)
                Image("iconUp")
                    .rotationEffect(.degrees(store.isShowEndPicker ? 0 : 180))
            }
            .onTapGesture {
                store.send(.endPickerTapped)
            }
            .padding(.top, 16)
            if store.isShowEndPicker {
                DDatePicker(date: $store.endDate)
                    .padding(.top, 8)
                    .animation(.easeInOut, value: store.isShowEndPicker)
            }
        }
        .padding(.leading, 16)
        .padding(.trailing, 16)
        .colorMultiply(!(store.planTitle.isEmpty) && !planFieldFocus ? Color.white : Color.gray.opacity(0.2))
        .disabled(store.planTitle.isEmpty || planFieldFocus)
    }
}

//#Preview {
//    ImprovePlanView(store: Store(initialState: ImprovePlan.State()) {
//        ImprovePlan()
//    })
//}
