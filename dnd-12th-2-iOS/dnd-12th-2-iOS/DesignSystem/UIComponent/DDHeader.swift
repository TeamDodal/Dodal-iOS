//
//  DDHeader.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 5/20/25.
//

import SwiftUI

struct DDHeader: View {
    var dateText: String
    var action: () -> Void
    
    var body: some View {
        HStack(spacing: 2) {
            Image(.iconCalendarBlue)
            Text(dateText)
                .font(.pretendard(size: 16, weight: .medium))
                .foregroundStyle(.mainBlue)
            Button(action: action) {
                Image(.iconForwardBlue)
            }
            Spacer()
        }
        .padding(.leading, 16)
        .padding(.vertical, 10)
    }
}
