//
//  Date+.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 5/12/25.
//


extension Date {
    static let calendarDayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy dd"
        return formatter
    }()
    
    var formattedCalendarDayDate: String {
        Date.calendarDayDateFormatter.string(from: self)
    }
}
