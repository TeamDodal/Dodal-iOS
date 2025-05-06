//
//  AppFlowCoordinatorView.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 5/6/25.
//

import SwiftUI

import ComposableArchitecture

struct AppFlowCoordinatorView: View {
    
    let store: StoreOf<AppFlowCoordinator>
    
    var body: some View {
        WithPerceptionTracking {
            SwitchStore(self.store) { state in
                switch state {
                case .mainTab:
                   Text("MainTab")
                case .onboarding:
                    Text("Onboarding")
                }
            }
        }
    }
}
