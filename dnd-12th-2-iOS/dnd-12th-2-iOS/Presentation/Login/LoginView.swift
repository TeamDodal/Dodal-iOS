//
//  LoginView.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 2/28/25.
//

import SwiftUI
import ComposableArchitecture
import AuthenticationServices

struct LoginView: View {
    @Perception.Bindable var store: StoreOf<LoginNavigation>
    @State var tabIndex = 0
    var body: some View {
        WithPerceptionTracking {
            NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
                VStack {
                    Spacer()
                    
                    TabView(selection: $tabIndex) {
                        VStack(spacing: 0) {
                            Spacer()
                           Image("onboardingImage1")
                                .resizable()
                                    .scaledToFit()
                        }
                        .tag(0)
                        
                        VStack(spacing: 0) {
                            Spacer()
                            Image("onboardingImage2")
                                .resizable()
                                    .scaledToFit()
                        }
                        .tag(1)
                        
                        VStack(spacing: 0) {
                            Spacer()
                            Image("onboardingImage3")
                                .resizable()
                                    .scaledToFit()
                            
                        }
                        .tag(2)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    
                    HStack(spacing: 8) {
                        ForEach(0..<3, id: \.self) { index in
                            Group {
                                if index == tabIndex {
                                    Circle()
                                        .frame(width: 8, height: 8)
                                        .foregroundColor(.black)
                                } else {
                                    Circle()
                                        .frame(width: 8, height: 8)
                                        .foregroundColor(Color.gray50)
                                }
                            }
                        }
                    }
                    .padding(.top, 36)
                    
                    Spacer()
                    
                    DDButton(image: Image("iconApple"),
                             imageSize: 20,
                             title: "애플 로그인",
                             font: .pretendard(size: 16, weight: .medium),
                             backgroundColor: .black,
                             cornerRadius: 12) {}
                        .overlay {
                            SignInWithAppleButton(
                                onRequest: { request in
                                    request.requestedScopes = [.fullName, .email]},
                                onCompletion: { result in
                                    switch result {
                                    case let .success(authorization):
                                        store.send(.appleLoginButtonTapped(authorization))
                                        break
                                    case .failure:
                                        break
                                    }
                                }
                            )
                            .blendMode(.overlay)
                        }
                        .padding(.top, 53)
                        .padding(.bottom, 12)
                }
                .padding(.horizontal, 20)
            } destination: { store in
                switch store.case {
                case let .onboarding(store):
                    OnboardingView(store: store)
                case let .setFirstGoal(store):
                    SetGoalFlowView(store: store)
                case let .goalResult(store):
                    GoalResultView(store: store)
                }
            }
        }
    }
}

//#Preview {
//    LoginView()
//}
