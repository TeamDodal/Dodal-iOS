//
//  TabBarView.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 5/13/25.
//

import SwiftUI

struct TabBarView: View {
    let currentTab: TabInfo
    var body: some View {
        HStack {
            ForEach(TabInfo.allCases, id: \.self) { tabInfo in
                HStack {
                    HStack {
                        Spacer()
                        VStack {                            
                            Image(tabInfo == currentTab ? tabInfo.iconSelected : tabInfo.icon)
                            Text(tabInfo.rawValue)
                                .font(.pretendard(size: 10, weight: .regular))
                                .foregroundStyle(currentTab == tabInfo ? .blue : .black)
                        }
                        Spacer()
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 4)
                }
            }
        }
        .overlay(alignment: .top) {
            Divider()
        }
        .background(.white)
        .allowsHitTesting(false)
    }
}

//#Preview {
//    TabBarView()
//}
