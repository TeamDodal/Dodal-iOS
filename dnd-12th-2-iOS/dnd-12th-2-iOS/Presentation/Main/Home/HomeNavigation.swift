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
        
        case goToFeedback(isSuccess: Bool, planInfo: Plan)
        
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
    }
    
    @Dependency(\.goalClient) var goalClient
    
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
                // MARK: - FetchPlan
            case .fetchPlan(.cellTapped):
                state.isShowSheet = true
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
                guard let planInfo = state.fetchPlan.plan else {
                    return .none
                }
                return .send(.goToFeedback(isSuccess: true, planInfo: planInfo))
            case .failureButtonTapped:
                state.isShowSheet = false
                guard let planInfo = state.fetchPlan.plan else {
                    return .none
                }
                return .send(.goToFeedback(isSuccess: false, planInfo: planInfo))
            default:
                return .none
            }
        }    
    }
}
