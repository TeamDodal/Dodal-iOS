//
//  ImprovePlan.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 3/15/25.
//

import Foundation

import ComposableArchitecture

@Reducer
struct ImprovePlan {
    // MARK: - State
    @ObservableState
    struct State {
        // Tip 받아오기
        var fetchTip: FetchTip.State
        
        // goalID
        var goalId = 0
        
        // 계획타이틀
        var planTitle = ""
        
        // 시작 날짜
        var startDate = Date()
        
        // 종료날짜
        var endDate = Date()
        
        // 화면이동 애니메이션
        var isFoward = true
        
        // 버튼 활성화여부
        var buttonDisabled: Bool {
            planTitle.isEmpty || !timePickerValidate
        }
        
        // 시간표시 관련
        let calendar: Calendar = {
            var calendar = Calendar.current
            calendar.timeZone = TimeZone.current
            return calendar
        }()
        
        // 시작날짜피커 숨김여부
        var isShowStartPicker = true
        
        // 종료날짜피커 숨김여부
        var isShowEndPicker = false
        
        // 피커 유효성검사
        var timePickerValidate: Bool {
            startDate <= endDate
        }
        
        // 시작날짜 구분
        var startDateToday: String {
            calendar.isDate(startDate, inSameDayAs: .now) ? "오늘" : "내일"
        }
        
        // 종료날짜 구분
        var endDateToday: String {
            calendar.isDate(endDate, inSameDayAs: .now) ? "오늘" : "내일"
        }
        
        // 시작날짜 문자 HH:mm
        var startDateStr: String {
            startDate.formatted("HH:mm")
        }
        
        // 종료날짜 문자 HH:mm
        var endDateStr: String {
            endDate.formatted("HH:mm")
        }
        
        // 오전/오후 + 시작날짜
        var startDateResultStr: String {
            startDateToday + " " + startDateStr
        }
        
        // 오전/오후 + 종료날짜
        var endDateResultStr: String {
            endDateToday + " " + endDateStr
        }
        
        // 종료날짜 결과 날짜가 다른경우 + 내일
        var endTimeResultStr: String {
            calendar.isDate(endDate, inSameDayAs: startDate) ? endDateStr : "내일" + " " + endDateStr
        }
        
        // 최종적으료 표시되는 날짜
        var resultTimeStr: String {
            startDateResultStr + " ~ " + endTimeResultStr
        }
        
        /// 새로운 계획생성(goalID 필수)
        /// - Parameter goalId: 계획을 생성할 목표의 goalID
//        init(goalId: Int) {
//            self.goalId = goalId
//            self.fetchTip = .init(guideType: .improvePlan)
//        }
        
        init() {
//            self.goalId = goalId
            self.fetchTip = .init(guideType: .improvePlan)
        }
    }
    
    // MARK: - Action
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case fetchTip(FetchTip.Action)
        
        // backButton Action
        case backButtonTapped
        
        // 완료액션
        case completeAction
        
        case startPickerTapped
        case endPickerTapped
        case improvePlan
    }
    
    // MARK: - Dependencies
    @Dependency(\.goalClient) var goalClient
    
    // MARK: - Reducer
    var body: some Reducer<State, Action> {
        BindingReducer()
        Scope(state: \.fetchTip, action: \.fetchTip) {
            FetchTip()
        }
        Reduce { state, action in
            switch action {
                // UI
//            case .startPickerTapped:
//                state.isShowStartPicker = true
//                state.isShowEndPicker = false
//                return .none
//            case .endPickerTapped:
//                state.isShowEndPicker = true
//                state.isShowStartPicker = false
//                return .none
//            case .nextButtonTapped:
//                return self.setNextButtonAction(&state)
//            case .backButtonTapped:
//                return self.setBackButtonAction(&state)
//            case .completeAction:
//                return self.setCompleteAction(&state)
//            case .nextAction:
//                let currentIndex = state.viewFlow.rawValue
//                state.viewFlow = .init(rawValue: currentIndex + 1)!
//                state.isFoward = true
//                if let guideType = state.viewFlow.guideType {
//                    state.fetchTip = .init(guideType: guideType)
//                }
//                return .none
//            case .cancleAction:
//                let currentIndex = state.viewFlow.rawValue
//                state.viewFlow = .init(rawValue: currentIndex - 1)!
//                state.isFoward = false
//                if let guideType = state.viewFlow.guideType {
//                    state.fetchTip = .init(guideType: guideType)
//                }
//                return .none
//                // API
//            case .requestMakePlan:
//                return .run { [state] send in
//                    try await goalClient.makePlan(state.goalId, .init(title: state.planTitle, startDate: state.startDate, endDate: state.endDate))
//                    await send(.requestRemoveFromStack)
//                }
//                // TODO: 목표생성 화면나오면 그때연결
//            case .requestMakeGoal:
//                return .run { send in
//                    
//                }
//            case .requestMakeFirstGoal:
//                return .run { [state] send in
//                    try await goalClient.makeGoal(.init(goalTitle: state.goalTitle, planTitle: state.planTitle, startDate: state.startDate, endDate: state.endDate))
//                    await send(.submitResult(goalTitle: state.goalTitle, planTitle: state.planTitle, startDate: state.startDate, endDate: state.endDate))
//                }
//            case .improvePlan:
//                return .none
                
            default:
                return .none
            }
        }
        ._printChanges()
    }
}
