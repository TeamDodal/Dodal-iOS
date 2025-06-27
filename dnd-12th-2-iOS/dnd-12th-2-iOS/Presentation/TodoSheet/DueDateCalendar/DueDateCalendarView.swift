//
//  DueDateView.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 6/25/25.
//

import SwiftUI
import ComposableArchitecture

struct DueDateCalendarView: View {
    @Perception.Bindable var store: StoreOf<DueDateCalendarFeature>
    var body: some View {
        WithPerceptionTracking {
            VStack {
                DDCalendar(selectedDate: $store.dueDate)
                
                DDButton(type: store.isSetDueDate ? .primary : .disabled, title: store.buttonTitle) {
                    store.send(.setDueDateButtonTapped)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

//#Preview {
//    DueDateView()
//}
