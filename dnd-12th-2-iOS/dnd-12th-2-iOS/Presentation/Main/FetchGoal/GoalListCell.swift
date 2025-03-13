//
//  GoalListCell.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 3/11/25.
//

import SwiftUI

struct GoalListCell: View {
    let goal: Goal
    let action: () -> Void
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .frame(width: 48, height: 48)
                .foregroundStyle(Color.purple50)
                .overlay(Image("appLogo"))
            
            VStack(spacing: 4) {
                HStack(spacing: 8) {
                    Text("계획 성공률")
                        .bodySmallMedium()
                        .foregroundStyle(Color.gray400)
                    Rectangle()
                        .frame(width: 1, height: 14)
                        .foregroundStyle(Color.gray400)
                    
                    Text("\(goal.successPercent)%")
                        .bodySmallBold()
                        .foregroundStyle(Color.purple600)
                    
                    Spacer()
                }
                Text(goal.title)
                    .bodyLargeSemibold()
                    .alignmentLeading()
                    .foregroundStyle(Color.gray700)
            }
            
            Spacer()
            Image("iconRight")
                .onTapGesture {
                    action()
                }
        }
        .padding(16)
        .background(.white)
        .cornerRadius(12)
    }
}

//#Preview {
//    GoalListCell()
//}
