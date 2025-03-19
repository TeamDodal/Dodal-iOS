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
        let planInfo: Plan
        // goalID
        let goalId: Int
        
        // planId
        var planId = 0
        
        // 계획타이틀
        var planTitle = ""
        
        // 시작 날짜
        var startDate = Date()
        
        // 종료날짜
        var endDate = Date()
        
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
        
        init(planInfo: Plan, goalId: Int) {
            self.fetchTip = .init(guideType: .improvePlan)
            self.planInfo = planInfo
            self.goalId = goalId
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
            case .startPickerTapped:
                state.isShowStartPicker = true
                state.isShowEndPicker = false
                return .none
            case .endPickerTapped:
                state.isShowEndPicker = true
                state.isShowStartPicker = false
                return .none
            case .backButtonTapped:
                return .none
            case .completeAction:
                return .none
                // API
            case .improvePlan:
                let planInfo = PlanInfo(title: state.planTitle, startDate: state.startDate, endDate: state.endDate)
                return .run { [state] send in
                    try await goalClient.improvePlan(state.goalId, state.planId, planInfo)
                }
            default:
                return .none
            }
        }
        ._printChanges()
    }
}
