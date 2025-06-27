//
//  Date+.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 5/12/25.
//

import Foundation

extension Date {
    static let calendarDayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy dd"
        return formatter
    }()
    
    var formattedCalendarDayDate: String {
        Date.calendarDayDateFormatter.string(from: self)
    }
    
    var toMonthDayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일"
        return formatter.string(from: self)
    }
    
    var toMonthDayWeekdayString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 (E)"
        return formatter.string(from: self)
    }
}
