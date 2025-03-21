//
//  DDFailPlanRow.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 3/21/25.
//

import SwiftUI

struct DDFailPlanRow: View {
    let planInfo: Plan
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Image("iconFail")
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(planInfo.period)
                        .font(.pretendard(size: 12, weight: .medium), lineHeight: 14)
                        .foregroundStyle(.gray500)
                        .padding(.bottom, 1)
                    Text(planInfo.title)
                        .bodyLargeSemibold()
                        .foregroundStyle(.gray900)
                }
                .padding(.leading, 12)
                Spacer()
            }
            .padding(.vertical, 13)
            .padding(.horizontal, 12)
        }
        .background(Color.pink100)
        .cornerRadius(12)
    }
}
