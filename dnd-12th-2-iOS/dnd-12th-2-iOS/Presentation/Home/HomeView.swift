//
//  HomeView.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 6/18/25.
//

import SwiftUI
import ComposableArchitecture
struct HomeView: View {
    @Perception.Bindable var store: StoreOf<HomeViewFeature>
    
    var body: some View {
        VStack {
            Button(action: {
                store.send(.view(.sheetPresent))
            }) {
                Text("button")
            }
            Text("Hello, World!")
        }
        .bottomSheet(isPresented: $store.isShowTodoSheet, content: {
            TodoSheetView(store: store.scope(state: \.todoSheetState, action: \.todoSheetAction))
                .fixedSize(horizontal: false, vertical: true)
        }, onDismiss: {
            store.send(.view(.sheetDismiss))
        })
    }
}

//#Preview {
//    HomeView()
//}
