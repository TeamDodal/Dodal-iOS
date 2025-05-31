//
//  DDCalendar.swift
//  dnd-12th-2-iOS
//
//  Created by Allie on 5/5/25.
//

import SwiftUI

struct DDCalendar: View {
    @State private var month: Date = Date()
    @Binding private var selectedDate: Date?
    
    init(
        month: Date = Date(),
        selectedDate: Binding<Date?>
    ) {
        _month = State(initialValue: month)
        _selectedDate = selectedDate
    }
    
    var body: some View {
        VStack {
            headerView
            calendarGridView
        }
    }
    
    // MARK: - Header
    private var headerView: some View {
        VStack {
            monthHeaderView
                .padding(.bottom, 8)
            
            HStack {
                ForEach(Self.weekday.indices, id: \.self) { symbol in
                    Text(Self.weekday[symbol])
                        .font(.pretendard(size: 12, weight: .medium))
                        .foregroundColor(Color.gray300)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.bottom, 4)
        }
    }
    
    // MARK: - Year & Month
    private var monthHeaderView: some View {
        HStack(alignment: .center, spacing: 12) {
            Button(
                action: {
                    changeMonth(by: -1)
                },
                label: {
                    Image("iconLeft")
                }
            )
            
            Text(month, formatter: Self.calendarHeaderDateFormatter)
                .font(.pretendard(size: 16, weight: .medium))
                .foregroundColor(Color.gray900)
            
            Button(
                action: {
                    changeMonth(by: 1)
                },
                label: {
                    Image("iconRight")
                }
            )
        }
    }
    
    // MARK: - Days
    private var calendarGridView: some View {
        let daysInMonth: Int = numberOfDays(in: month)
        let firstWeekday: Int = firstWeekdayOfMonth(in: month) - 1
        let numberOfRows = Int(ceil(Double(daysInMonth + firstWeekday) / 7.0))
        let visibleDaysOfNextMonth = numberOfRows * 7 - (daysInMonth + firstWeekday)
        
        return LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
            ForEach(-firstWeekday ..< daysInMonth + visibleDaysOfNextMonth, id: \.self) { index in
                Group {
                    if index > -1 && index < daysInMonth {
                        let date = getDate(for: index)
                        let day = Calendar.current.component(.day, from: date)
                        let isSelected = selectedDate == date
                        let isToday = date.formattedCalendarDayDate == today.formattedCalendarDayDate
                        
                        DayCellView(day: day, isSelected: isSelected, isToday: isToday)
                            .onTapGesture {
                                selectedDate = date
                            }
                    } else {
                        Color.clear
                            .frame(height: 46)
                    }
                }
            }
        }
    }
}

// MARK: - Days Cell
private struct DayCellView: View {
    private var day: Int
    private var isSelected: Bool
    private var isToday: Bool
    
    private var textColor: Color {
        if isSelected {
            return Color.gray900
        } else if isToday {
            return Color.mainBlue
        } else {
            return Color.gray700
        }
    }
    private var backgroundColor: Color {
        if isSelected {
            return Color.gray50
        } else {
            return Color.white
        }
    }
    
    fileprivate init(
        day: Int,
        isSelected: Bool = false,
        isToday: Bool = false
    ) {
        self.day = day
        self.isSelected = isSelected
        self.isToday = isToday
    }
    
    fileprivate var body: some View {
        VStack {
            if isSelected {
                RoundedRectangle(cornerRadius: 12)
                    .fill(backgroundColor)
                    .overlay(Text(String(day))
                        .font(.pretendard(size: 16, weight: .semibold)))
                    .foregroundColor(textColor)
                    .frame(width: 46, height: 52)
            } else {
                Text(String(day))
                    .font(.pretendard(size: 16, weight: .regular))
                    .foregroundColor(textColor)
            }
        }
        .frame(height: 46)
    }
}

private extension DDCalendar {
    var today: Date {
        Calendar.current.startOfDay(for: Date())
    }
    
    static let calendarHeaderDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월"
        return formatter
    }()
    
    static let weekday: [String] = ["일", "월", "화", "수", "목", "금", "토"]
}

private extension DDCalendar {
    func getDate(for index: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: index, to: startOfMonth) ?? Date()
    }
    
    func numberOfDays(in date: Date) -> Int {
        Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    func firstWeekdayOfMonth(in date: Date) -> Int {
        Calendar.current.component(.weekday, from: startOfMonth)
    }
    
    func changeMonth(by value: Int) {
        self.month = adjustedMonth(by: value)
    }
    
    func adjustedMonth(by value: Int) -> Date {
        Calendar.current.date(byAdding: .month, value: value, to: month) ?? month
    }
    
    var startOfMonth: Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: month)) ?? month
    }
}


#Preview {
    DDCalendar(selectedDate: .constant(.now))
}
