//
//  DDAddTaskButton.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 4/29/25.
//

import SwiftUI

struct DDAddTaskButton: View {
    let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(.iconPlus)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .padding(.leading, 12)
                Text("할 일 추가")
                    .font(.pretendard(size: 16, weight: .medium))
                    .foregroundStyle(.gray0)
                    .padding(.trailing, 16)
            }
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 42)
                    .fill(.mainBlue)
            }
        }
    }
}
