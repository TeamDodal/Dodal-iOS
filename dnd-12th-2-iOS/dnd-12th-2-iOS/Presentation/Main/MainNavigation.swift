//
//  MainNavigation.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 3/5/25.
//

import ComposableArchitecture

@Reducer
struct MainNavigation {
    @Reducer
    enum Path {
        case home(HomeNavigation)
        case setGoal(SetGoalFlow)
        case myPage(MyPage)
        case goalResult(GoalResult)
        case achieveGoal(AchieveGoal)
        case feedbackComplete(FeedbackComplete)
        case fetchFeedback(FetchFeedback)
        case feedbackResult(FeedbackResult)
        case feedbackDetail(FeedbackDetail)
        case improvePlan(ImprovePlan)
    }
    
    @ObservableState
    struct State {
        var path = StackState<Path.State>()
        var fetchGoal = FetchGoal.State()
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case path(StackActionOf<Path>)
        // 목표설정으로 이동
        case goToSetGoalView
        // 마이페이지로 이동
        case goToMyPage
        case fetchGoal(FetchGoal.Action)
        // 목표달성으로 이동
        case goToAchieveGoal(goalId: Int)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.fetchGoal, action: \.fetchGoal) {
            FetchGoal()
        }
        Reduce { state, action in
            switch action {
            case .fetchGoal(.goToSetGoal):
                state.path.append(.setGoal(.init(makeType: .firstGoal)))
                return .none
                // MARK: - MainView
            case .goToSetGoalView:
                state.path.append(.setGoal(.init(makeType: .firstGoal)))
                return .none
            case .goToMyPage:
                state.path.append(.myPage(.init()))
                return .none
                // goalID 넘겨주고 상세화면 이동
            case let .fetchGoal(.cellTapped(goalInfo)):                
                state.path.append(.home(.init(goalId: goalInfo.goalId, goalTitle: goalInfo.title)))
                return .none
            case let .goToAchieveGoal(goalId):
                state.path.append(.achieveGoal(.init(goalId: goalId)))
                return .none
                // MARK: - Flow
            case let .path(action):
                switch action {
                case let .element(id: id, action: .myPage(.backButtonTapped)):
                    state.path.pop(from: id)
                    return .none
                case let .element(id: id, action: .home(.backButtonTapped)):
                    state.path.pop(from: id)
                    return .none
                case let .element(id: id, action: .home(.deleteGoalCompleted)):
                    state.path.pop(from: id)
                    return .none
                case let .element(id: id, action: .setGoal(.requestRemoveFromStack)):
                    state.path.pop(from: id)
                    return .none
                    // TODO: - 목표달성 연결
                case let .element(id: id, action: .home(.goToAchieveGoal(goalId))):
                    state.path.pop(from: id)
                    return .send(.goToAchieveGoal(goalId: goalId))
                case let .element(id: _, action: .home(.goToSetPlan(goalId))):
                    state.path.append(.setGoal(.init(goalId: goalId)))
                    return .none
                case let .element(id: _, action: .setGoal(.submitResult(goalTitle, planTitle, startDate, endDate))):
                    state.path.append(.goalResult(.init(goalTitle: goalTitle, planTitle: planTitle, startDate: startDate, endDate: endDate)))
                    return .none
                case .element(id: _, action: .goalResult(.goToMain)):
                    state.path.removeAll()
                    return .none
                case let .element(id: _, action: .home(.goToFeedbackDeatail(planInfo, goalId))):
                    var newPlanInfo = planInfo
                    if planInfo.resultType == .success {
                        newPlanInfo.completeType = .success
                    } else {
                        newPlanInfo.completeType = .failure
                    }
                    state.path.append(.feedbackResult(.init(planInfo: newPlanInfo)))
                    return .none
                case let .element(id: id, action: .feedbackResult(.backButtonTapped)):
                    state.path.pop(from: id)
                    return .none
                case .element(id: _, action: .achieveGoal(.goToSetGoal)):
                    return .send(.goToSetGoalView)
                case let .element(id: id, action: .achieveGoal(.goToHome)):
                    state.path.pop(from: id)
                    return .none
                    // Feedback
                case let .element(id: _, action: .home(.goToFeedback(planInfo, goalId))):
                    state.path.append(.feedbackComplete(.init(planInfo: planInfo, goalId: goalId)))
                    return .none
                case let .element(id: id, action: .feedbackComplete(.backButtonTapped)):
                    state.path.pop(from: id)
                    return .none
                case let .element(id: _, action: .feedbackComplete(.goToFeedback(planInfo, goalId))):
                    state.path.append(.fetchFeedback(.init(planInfo: planInfo, goalId: goalId)))
                    return .none
                case let .element(id: _, action: .fetchFeedback(.goToFeedbackResult(planInfo, goalId))):
                    state.path.append(.feedbackResult(.init(planInfo: planInfo, goalId: goalId)))
                    return .none
                case let .element(id: id, action: .fetchFeedback(.backButtonTapped)):
                    state.path.pop(from: id)
                    return .none
                case .element(id: _, action: .feedbackResult(.completeButtonTapped)):
                    state.path.removeSubrange(state.path.count-3..<state.path.count)
                    return .none
                    // Improve Plan
                case let .element(id: _, action: .feedbackResult(.goToImprovePlan(planInfo, goalId, planId))):
                    state.path.append(.improvePlan(.init(planInfo: planInfo, goalId: goalId, planId: planId)))
                    return .none
                case .element(id: _, action: .improvePlan(.backButtonTapped)):
                    state.path.removeSubrange(state.path.count-4..<state.path.count)
                    return .none
                case .element(id: _, action: .improvePlan(.completeAction)):
                    state.path.removeSubrange(state.path.count-4..<state.path.count)
                    return .none
                case .element(id: _, action: .improvePlan(.deletePlan)):
                    state.path.removeSubrange(state.path.count-4..<state.path.count)
                    return .none
                default:
                    return .none
                }
            default:
                return .none
            }
        }.forEach(\.path, action: \.path)
    }
}
