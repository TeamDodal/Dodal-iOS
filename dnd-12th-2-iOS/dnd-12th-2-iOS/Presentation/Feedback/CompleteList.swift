//
//  CompleteList.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 2/13/25.
//

import SwiftUI

struct CompleteList: View {
    let result: [ResultPlan]
    var body: some View {
        
        VStack(spacing: 0) {
            if result.count > 3 {
                let firstPlan = result[0]
                let lastPlan = result[result.count - 2]
                
                HStack(alignment: .top) {
                    Image(firstPlan.isSuccess ? "iconFeedbackSuccess" : "iconFeedbackFail")
                    VStack(alignment: .leading, spacing: 8) {
                        Text(firstPlan.title)
                            .bodyMediumSemibold()
                            .alignmentLeading()
                            .foregroundStyle(.gray900)
                        
                        HStack {
                            Text("개선할 점 | ")
                                .bodySmallBold()
                                .foregroundStyle(.purple700)
                            Text(firstPlan.guide ?? "")
                                .bodySmallMedium()
                                .foregroundStyle(.gray700)
                        }
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(.white)
                        .cornerRadius(8)
                    }
                    Spacer()
                }
                
                Image("iconHistory")
                    .padding(.vertical, 16)
                
                HStack(alignment: .top) {
                    Image(lastPlan.isSuccess ? "iconFeedbackSuccess" : "iconFeedbackFail")
                    VStack(alignment: .leading, spacing: 8) {
                        Text(lastPlan.title)
                            .bodyMediumSemibold()
                            .alignmentLeading()
                            .foregroundStyle(.gray900)
                        
                        HStack {
                            Text("개선할 점 | ")
                                .bodySmallBold()
                                .foregroundStyle(.purple700)
                            Text(lastPlan.guide ?? "")
                                .bodySmallMedium()
                                .foregroundStyle(.gray700)
                        }
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(.white)
                        .cornerRadius(8)
                    }
                    Spacer()
                }
            }
            else if result.count > 1  {
                LazyVStack(spacing: 20) {
                    ForEach(Array(result.prefix(result.count > 2 ? 2 : 1)), id: \.self) { plan in
                        HStack(alignment: .top) {
                            Image(plan.isSuccess ? "iconFeedbackSuccess" : "iconFeedbackFail")
                            VStack(alignment: .leading, spacing: 8) {
                                Text(plan.title)
                                    .bodyMediumSemibold()
                                    .alignmentLeading()
                                    .foregroundStyle(.gray900)
                                
                                HStack {
                                    Text("개선할 점 | ")
                                        .bodySmallBold()
                                        .foregroundStyle(.purple700)
                                    Text(plan.guide ?? "")
                                        .bodySmallMedium()
                                        .foregroundStyle(.gray700)
                                }
                                .padding(.vertical, 6)
                                .padding(.horizontal, 12)
                                .background(.white)
                                .cornerRadius(8)
                            }
                            Spacer()
                        }
                    }
                }
            }
            if result.count > 1 {
                Image("iconLine")
                    .padding(.vertical, 24)
            }
            HStack {
                if let lastPlan = result.last {
                    Image(lastPlan.isSuccess ? "iconFeedbackSuccess" : "iconFeedbackFail")
                    Text(lastPlan.title)
                        .bodyMediumSemibold()
                        .foregroundStyle(.gray900)
                    Spacer()
                }
            }
        }
        .padding(16)
        .background(.gray50)
        .cornerRadius(12)
    }
}

//#Preview {
//    CompleteList()
//}
