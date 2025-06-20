//
//  HomeView.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 6/18/25.
//

import SwiftUI

struct HomeView: View {
    @State var isPresented: Bool = false
    var body: some View {
        VStack {
            Button(action: {
                isPresented = true
            }) {
                Text("button")
            }
            Text("Hello, World!")
        }
        .bottomSheet(isPresented: $isPresented) {
            VStack {
                TextField(text: .constant("")) {
                    Text("text")
                }
            }
        }        
    }
}

#Preview {
    HomeView()
}
