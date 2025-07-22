//
//  DDButton.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 4/29/25.
//

import SwiftUI

struct DDButton: View {
    enum ButtonType {
        case primary
        case secondary
        case disabled
        
        var textColor: Color {
            switch self {
            case .primary: .gray0
            case .secondary: .mainBlue
            case .disabled: .gray0
            }
        }
        
        var backgroundColor: Color {
            switch self {
            case .primary: .mainBlue
            case .secondary: .secondaryBlue
            case .disabled: .gray300
            }
        }
        
        var isEnabled: Bool {
            self != .disabled
        }
    }
    
    let type: ButtonType
    let title: String
    let action: () -> Void
    
    init(type: ButtonType, title: String,
         action: @escaping () -> Void) {
        self.type = type
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button {
            if type.isEnabled {
                action()
            }
        } label : {
            Text(title)
                .font(.pretendard(size: 16, weight: .medium))
                .foregroundStyle(type.textColor)
                .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 15)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(type.backgroundColor)
        }
        .disabled(!type.isEnabled)
    }
}
