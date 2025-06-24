//
//  OnboardingFeature.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 5/18/25.
//

import Foundation

import ComposableArchitecture

@Reducer
struct OnboardingFeature {
    @ObservableState
    struct State {
        var title: String = ""
        var tasks: [String] = Array(repeating: "", count: 5)
        var isLastStep: Bool = false
        let taskPlaceholders: [String] = [
            "가장 먼저 할 일",
            "다음으로 할 일",
            "그 다음으로 할 일",
            "그 다음으로 할 일",
            "그 다음으로 할 일"
        ]
    }

    enum Action: ViewAction, TCAAction {
        case view(ViewAction)
        case external(ExternalAction)
        case destination(DestinationAction)

        enum ViewAction: BindableAction {
            case binding(BindingAction<State>)
            case nextButtonTapped
            case backButtonTapped
            case completeButtonTapped
        }

        enum ExternalAction {
            case saveTodo
            case onboardingCompleted
        }

        enum DestinationAction {}
    }

    @Dependency(\.todoClient) var todoClient

    var body: some Reducer<State, Action> {
        BindingReducer(action: \.view)
        Reduce { state, action in
            switch action {
            // MARK: - View Actions
            case let .view(viewAction):
                switch viewAction {
                case .binding:
                    return .none
                case .nextButtonTapped:
                    state.isLastStep = true
                    return .none
                case .backButtonTapped:
                    state.isLastStep = false
                    return .none
                case .completeButtonTapped:
                    return .send(.external(.saveTodo))
                }
            // MARK: - External Actions
            case let .external(externalAction):
                switch externalAction {
                case .saveTodo:
                    return .run { [state] send in
                        try todoClient.createTodoWithSubTodos(state.title, state.tasks)
                        await send(.external(.onboardingCompleted))
                    }
                default:
                    return .none
                }
            // MARK: - Destination Actions
            case .destination:
                return .none
            }
        }
    }
}
