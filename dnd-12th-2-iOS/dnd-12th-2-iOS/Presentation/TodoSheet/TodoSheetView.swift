//
//  TodoSheetView.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 6/20/25.
//

import SwiftUI
import ComposableArchitecture

struct TodoSheetView: View {
    
    @Perception.Bindable var store: StoreOf<TodoSheetFeature>
    
    var body: some View {
        WithPerceptionTracking {
            if let currentView = store.currentView {
                VStack {
                    if !store.isRootView {
                        HStack {
                            Button(action: {
                                store.send(.backButtonTapped)
                            }) {
                                Image(.iconBack)
                            }
                            Spacer()
                            Text(currentView.title)
                                .font(.pretendard(size: 18, weight: .semibold))
                            Spacer()
                            Image(.iconBack)
                                .opacity(0)
                        }
                        .frame(height: 32)
                        .padding(.top, 12)
                        .padding(.horizontal, 16)
                    }
                    switch currentView {
                    case .editTodo:
                        TodoEditorView(store: store.scope(state: \.todoState, action: \.todoAction))
                    case .setDueDate:
                        DueDateCalendarView(store: store.scope(state: \.calendarState, action: \.calendarAction))
                    }
                }
                .animation(.default, value: store.currentView)
                .transition(store.isRootView ?   AnyTransition.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .leading)) :   AnyTransition.asymmetric(
                        insertion: .move(edge: .leading),
                        removal: .move(edge: .trailing)))
            } else {
                EmptyView()
            }
        }
    }
    
}

//#Preview {
//    TodoSheetView()
//}
