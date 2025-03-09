//
//  SetGoalView.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 3/5/25.
//

import SwiftUI
import ComposableArchitecture

struct SetGoalFlowView: View {
    @Perception.Bindable var store: StoreOf<SetGoalFlow>
    @FocusState var isFocused: Bool
    var body: some View {
        WithPerceptionTracking {
            ScrollView {
                switch store.viewFlow {
                case .setGoal:
                    VStack(spacing: 0) {
                        Text(store.viewFlow.title)
                            .headingStyle1()
                            .alignmentLeading()
                            .foregroundStyle(Color.gray900)
                            .padding(.top, 40)
                        DDTextField(text:  $store.goalTitle)
                            .padding(.top, 20)
                        TipView(store: store.scope(state: \.fetchTip, action: \.fetchTip))
                            .padding(.top, 8)
                        Spacer()
                        DDButton(title: store.buttonText, isDisable: store.buttonDisabled){
                            store.send(.nextButtonTapped)
                        }
                    }
                case .setPlan:
                    VStack(spacing: 0) {
                        Text(store.viewFlow.title)
                            .headingStyle1()
                            .alignmentLeading()
                            .foregroundStyle(Color.gray900)
                            .padding(.top, 40)
                        DDRoundTextFiled(text: $store.planTitle, isFocused: $isFocused)
                            .padding(.top, 20)
                        TipView(store: store.scope(state: \.fetchTip, action: \.fetchTip))
                            .padding(.top, 8)
                        DateGroup()
                            .padding(.top, 40)
                        Spacer()
                        DDButton(title: store.buttonText, isDisable: store.buttonDisabled){
                            store.send(.nextButtonTapped)
                        }
                    }
                    .onTapGesture {
                        UIApplication.shared.hideKeyboard()
                    }
                }
            }
            .scrollDisabled(true)
            .navigationBar(left: {
                DDBackButton(action: {
                    store.send(.backButtonTapped)
                })
            })
            .id(store.viewFlow)
            .animation(.default, value: store.viewFlow)
            .transition(store.isFoward ? AnyTransition.asymmetric(
                insertion: .move(edge: .trailing),
                removal: .move(edge: .leading)) :   AnyTransition.asymmetric(
                    insertion: .move(edge: .leading),
                    removal: .move(edge: .trailing)))
            .ignoresSafeArea(.keyboard)
        }
    }
}

extension SetGoalFlowView {
    @ViewBuilder
    func DateGroup() -> some View {
        VStack(spacing: 0) {
            Text("시간")
                .headingStyle1()
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
                Text("시작 시간")
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
                Text("종료 시간")
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
        .colorMultiply(!(store.planTitle.isEmpty) && !isFocused ? Color.white : Color.gray.opacity(0.2))
        .disabled(store.planTitle.isEmpty || isFocused)
    }
}

//#Preview {
//    SetGoalView()
//}
