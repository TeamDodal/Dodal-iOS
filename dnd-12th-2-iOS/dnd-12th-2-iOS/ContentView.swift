//
//  ContentView.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 1/22/25.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {        
    
    var body: some View {
        WithPerceptionTracking {
            AppFlowCoordinatorView(store: Store(initialState: AppFlowCoordinator.State(), reducer: {
                AppFlowCoordinator()
            }))
            .ignoresSafeArea(.keyboard)
        }
    }
}

//#Preview {
//    ContentView()
//}
