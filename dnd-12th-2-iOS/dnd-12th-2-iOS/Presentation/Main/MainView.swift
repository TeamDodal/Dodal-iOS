//
//  MainView.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 5/6/25.
//

import SwiftUI

import ComposableArchitecture

struct MainView: View {
    fileprivate let store: StoreOf<MainViewFeature>
    
    var body: some View {
        VStack {
            Spacer()
            Button(action: {
                
            }, label: {
                Text("Todo create")
            })
            .buttonStyle(.borderedProminent)
            
        }
        //        .sheet(isPresented: $isShowSheet) {
        //            VStack {
        //                TextField("title", text: $title)
        //                    .textFieldStyle(.roundedBorder)
        //
        //                Button(action: {}, label: {
        //                    Text("Todo create")
        //                })
        //                .buttonStyle(.borderedProminent)
        //            }
        //        }
    }
}

#Preview {
    MainView(store: .init(initialState: MainViewFeature.State(), reducer: {
        MainViewFeature()
    }))
}
