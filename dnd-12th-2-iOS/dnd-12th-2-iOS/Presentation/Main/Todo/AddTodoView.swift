//
//  AddTodoView.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 5/12/25.
//

import SwiftUI

import ComposableArchitecture

struct AddTodoView: View {
    @Perception.Bindable fileprivate var store: StoreOf<TodoFeature>
    
    init(store: StoreOf<TodoFeature>) {
        self.store = store
    }
    
    var body: some View {
        WithPerceptionTracking {
            VStack {
                TextField("title", text: $store.title)
                    .textFieldStyle(.roundedBorder)
                
                Button(action: {
                    store.send(.view(.addTodoButtonTapped))
                }, label: {
                    Text("Todo create")
                })
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

#Preview {
    AddTodoView(store: .init(initialState: TodoFeature.State(), reducer: {
        TodoFeature()
    }))
}
