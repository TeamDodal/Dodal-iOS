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
            switch store.viewState {
            case .editTodo:
                TodoEditorView(store: store.scope(state: \.todoState, action: \.todoAction))
            case .setDueDate:
                DueDateCalendarView(store: store.scope(state: \.calendarState, action: \.calendarAction))
            }
        }
    }

}

//#Preview {
//    TodoSheetView()
//}
