//
//  HomeNavigation.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 2/28/25.
//

import ComposableArchitecture

@Reducer
struct HomeNavigation {
    
    @ObservableState
    struct State {
        var isShowSheet = false
        var isShowMenu = false
        var isShowGoalList = false
        var isCustomAlertPresented = false
        var isShowDeleteAlert = false
        var isShowPlanDeleteAlert = false
        var calendar: MakeCalendar.State
        var fetchPlan: FetchPlan.State
        let goalTitle: String
        let goalId: Int
        
        init(goalId: Int, goalTitle: String) {
            self.goalId = goalId
            self.goalTitle = goalTitle
            self.calendar = .init(goalId: goalId)
            self.fetchPlan = .init(goalId: goalId)
        }
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        // 메뉴 숨김여부
        case showMenu
                
        case hideMenu
        
        case backButtonTapped
        
        // 목표달성
        case goToAchieveGoal(goalId: Int)
        
        case completeButtonTapped
        
        case failureButtonTapped
        
        case goToFeedback(planInfo: Plan, goalId: Int)
        
        case addPlanButtonTapped
        
        // 계획설정으로 이동
        case goToSetPlan(goalId: Int)
        
        // 캘린더
        case calendar(MakeCalendar.Action)
        
        // 목표리스트
        case fetchPlan(FetchPlan.Action)
        case showAlert
        case customAlertDismissed
        case confirmButtonTapped
        case achieveGoal(goalId: Int)
        case showDeleteAlert
        case showDeleteAlertDismissed
        case showPlanDeleteAlert
        case planDeleteAlertDismissed
        case deleteGoal
        case deleteGoalCompleted
        case deletePlan
        case deletePlanRequest
        case goToFeedbackDeatail
    }
    
    @Dependency(\.goalClient) var goalClient
    @Dependency(\.planClient) var planClient
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Scope(state: \.calendar, action: \.calendar) {
            MakeCalendar()
        }
        Scope(state: \.fetchPlan, action: \.fetchPlan) {
            FetchPlan()
        }
        Reduce { state, action in
            switch action {
            case .hideMenu:
                state.isShowMenu = false
                return .none
            case .showMenu:
                state.isShowMenu = true
                return .none
            case .addPlanButtonTapped:
                return .send(.goToSetPlan(goalId: state.goalId))
            case .showDeleteAlert:                
                state.isShowDeleteAlert = true
                return .none
            case .showDeleteAlertDismissed:
                state.isShowDeleteAlert = false
                return .none
            case .deleteGoal:
                return .run { [state] send in
                    try await goalClient.deleteGoal(state.goalId)
                    await send(.deleteGoalCompleted)
                }
            case .showPlanDeleteAlert:
                state.isShowPlanDeleteAlert = true
                state.isShowSheet = false
                return .none
            case .planDeleteAlertDismissed:
                state.isShowPlanDeleteAlert = false
                return .none
            case .deletePlanRequest:
                guard let planId = state.fetchPlan.plan?.planId else {
                    return .none
                }
                return .run { send in
                    try await planClient.deletePlan(planId)
                }
            case .deletePlan:
                let date = state.calendar.requestDate
                return .concatenate([
                    .send(.deletePlanRequest),
                    .send(.planDeleteAlertDismissed),
                    .send(.fetchPlan(.fetchPlans(date))),
                    .send(.calendar(.fetchWeeklyGoal))
                ])
                // MARK: - FetchPlan
            case .fetchPlan(.cellTapped):
                if let planInfo = state.fetchPlan.plan, planInfo.resultType == .ready {
                    state.isShowSheet = true
                } else {
                    return .send(.goToFeedbackDeatail)
                }
                return .none
                // MARK: - Calendar
            case let .calendar(action):
                switch action {
                    // 캘린더 날짜변경시 계획리스트 새로고침
                case let .requestScrollId(date):
                    return .send(.fetchPlan(.responseScrollId(date)))
                case let .requestDate(date):
                    return .send(.fetchPlan(.requestPlan(date)))
                default:
                    return .none
                }
            case .showAlert:
                state.isShowMenu = false
                state.isCustomAlertPresented = true
                return .none
            case .customAlertDismissed:
                state.isCustomAlertPresented = false
                return .none
            case .confirmButtonTapped:
                return .send(.achieveGoal(goalId: state.goalId))
            case .achieveGoal:
                return .run { [state] send in
                    let goalId = state.goalId
                    try await goalClient.achieveGoal(goalId)
                    await send(.goToAchieveGoal(goalId: state.goalId))
                }
            case .completeButtonTapped:
                state.isShowSheet = false
                guard var planInfo = state.fetchPlan.plan else {
                    return .none
                }
                planInfo.completeType = .success
                return .send(.goToFeedback(planInfo: planInfo, goalId: state.goalId))
            case .failureButtonTapped:
                state.isShowSheet = false
                guard var planInfo = state.fetchPlan.plan else {
                    return .none
                }
                planInfo.completeType = .failure
                return .send(.goToFeedback(planInfo: planInfo, goalId: state.goalId))
            default:
                return .none
            }
        }    
    }
}
