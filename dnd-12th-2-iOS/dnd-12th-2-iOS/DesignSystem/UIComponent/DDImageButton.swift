//
//  DDImageButton.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 4/29/25.
//

import SwiftUI

struct DDImageButton: View {
    enum ButtonType {
        case dueDate
        case dueDateActive
        case complete        
        
        var image: Image {
            switch self {
            case .dueDate: Image(.iconCalendarGray)
            case .dueDateActive: Image(.iconCalendar)
            case .complete: Image(.iconCheckBlack)
            }
        }
        var textColor: Color {
            switch self {
            case .dueDate: .gray500
            case .dueDateActive: .mainBlue
            case .complete: .gray900
            }
        }
        var backgroundColor: Color {
            switch self {
            case .dueDate: .gray0
            case .dueDateActive: .gray0
            case .complete: .gray50
            }
        }
        var borderColor: Color {
            switch self {
            case .dueDate: .gray200
            case .dueDateActive: .mainBlue
            case .complete: .gray0
            }
        }
        var defaultText: String {
            switch self {
            case .dueDate: "마감일"
            case .dueDateActive: ""
            case .complete: "완료로 표시"
            }
        }
    }
    
    let type: ButtonType
    let text: String?
    let action: () -> Void
    
    init(type: ButtonType,
         text: String?,
         action: @escaping () -> Void) {
        self.type = type
        self.text = text
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                type.image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                Text(text ?? type.defaultText)
                    .font(.pretendard(size: 14, weight: .medium))
                    .foregroundStyle(type.textColor)
            }
            .padding(.vertical, 6.5)
            .padding(.horizontal, 8)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(type.backgroundColor)
                RoundedRectangle(cornerRadius: 8)
                    .stroke(type.borderColor, lineWidth: 1)
                
            }
        }
    }
}
