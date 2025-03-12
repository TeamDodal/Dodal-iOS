//
//  DDAlert.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 3/11/25.
//

import SwiftUI

struct DDAlert: View {
    let title: String
    let cancelButtonTitle: String
    let confirmButtonTitle: String
    let onCancel: () -> Void
    let onConfirm: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    onCancel()
                }
            
            VStack {
                Text(title)
                    .font(.pretendard(size: 18, weight: .semibold))
                    .foregroundStyle(.gray900)
                
                HStack {
                    DDButton(title: cancelButtonTitle,
                             font: .pretendard(size: 16, weight: .medium),
                             backgroundColor: .gray50,
                             textColor: .gray900,
                             width: 104,
                             height: 48,
                             cornerRadius: 12) {
                        onCancel()
                    }
                    DDButton(title: confirmButtonTitle,
                             font: .pretendard(size: 16, weight: .medium),
                             backgroundColor: .purple500,
                             textColor: .white,
                             width: 104,
                             height: 48,
                             cornerRadius: 12) {
                        onConfirm()
                    }
                }
                .padding(.top, 14)
            }
            .padding(20)
            .background(.white)
            .cornerRadius(12)
        }
    }
}
