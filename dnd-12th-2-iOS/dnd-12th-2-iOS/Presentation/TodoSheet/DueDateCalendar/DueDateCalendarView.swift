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
//                HStack {
//                    Text("마감일")
//                        .font(.pretendard(size: 18, weight: .semibold))
//                }
//                .frame(height: 32)
//                .padding(.top, 12)
                
                DDCalendar(selectedDate: $store.dueDate)
                
                DDButton(type: store.dueDate == nil ? .disabled : .primary, title: store.buttonTitle) {
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
