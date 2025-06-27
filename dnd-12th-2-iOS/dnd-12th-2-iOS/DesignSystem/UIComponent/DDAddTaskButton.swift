//
//  DDAddTaskButton.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 4/29/25.
//

import SwiftUI

struct DDAddTaskButton: View {
    enum ButtonType {
        case parent
        case child
        
        var text: String {
            switch self {
            case .parent: "할 일 추가"
            case .child: "하위 할 일 추가"
                
            }
        }
    }
    
    let buttonType: ButtonType
    let action: () -> Void
    
    init(type: ButtonType, action: @escaping () -> Void) {
        self.buttonType = type
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
                Text(buttonType.text)
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
