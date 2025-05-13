//
//  TabInfo.swift
//  dnd-12th-2-iOS
//
//  Created by 권석기 on 5/13/25.
//

import Foundation

enum TabInfo: String, CaseIterable {
    case main = "홈"
    case todo = "할일"
    case setting = "설정"
    
    var icon: ImageResource {
        switch self {
        case .main: .iconHomeGray
        case .todo: .iconTaskGray
        case .setting: .iconSettingGray
        }
    }
    
    var iconSelected: ImageResource {
        switch self {
        case .main: .iconHome
        case .todo: .iconTask
        case .setting:.iconSetting
        }
    }
}
