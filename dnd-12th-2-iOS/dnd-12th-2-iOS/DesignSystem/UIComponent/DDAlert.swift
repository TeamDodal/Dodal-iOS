//
//  DDAlert.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 6/3/25.
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
                    Button(action: onCancel) {
                        HStack {
                            Text(cancelButtonTitle)
                                .font(.pretendard(size: 16, weight: .medium))
                                .foregroundStyle(.gray900)
                        }
                        .frame(maxWidth: 104 == .infinity ? .infinity : 104, minHeight: 48, maxHeight: 48)
                        .background(.gray50)
                        .cornerRadius(12)
                    }
                    
                    Button(action: onConfirm) {
                        HStack {
                            Text(confirmButtonTitle)
                                .font(.pretendard(size: 16, weight: .medium))
                                .foregroundStyle(.gray0)
                        }
                        .frame(maxWidth: 104 == .infinity ? .infinity : 104, minHeight: 48, maxHeight: 48)
                        .background(.mainBlue)
                        .cornerRadius(12)
                    }
                }
                .padding(.top, 14)
            }
            .padding(20)
            .background(.gray0)
            .cornerRadius(12)
        }
    }
}
    
#Preview {
    DDAlert(title: "할 일을 정말 삭제할까요?", cancelButtonTitle: "취소", confirmButtonTitle: "삭제", onCancel: {}, onConfirm: {})
}
