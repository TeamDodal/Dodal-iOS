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
    @State private var dragOffset: CGFloat = 0
    
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
                .offset(x: dragOffset)
                .animation(.interactiveSpring(), value: dragOffset)
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    dragOffset = value.translation.width
                }
                .onEnded { value in
                    let threshold: CGFloat = 80
                    if value.translation.width < -threshold {
                        changeMonth(by: 1)
                    } else if value.translation.width > threshold {
                        changeMonth(by: -1)
                    }
                    dragOffset = 0
                }
        )
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
        }.transaction {
            $0.disablesAnimations = true
        }
    }
    
    // MARK: - Days
    private var calendarGridView: some View {
        let daysInMonth = numberOfDays(in: month)
        let firstWeekday = firstWeekdayOfMonth(in: month) - 1
        let numberOfRows = Int(ceil(Double(daysInMonth + firstWeekday) / 7.0))
        
        /// 이전 달 정보
        let prevMonth = adjustedMonth(by: -1)
        let daysInPrevMonth = numberOfDays(in: prevMonth)
        
        return LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
            ForEach(0 ..< (numberOfRows * 7), id: \.self) { index in
                let dayOffset = index - firstWeekday
                if dayOffset < 0 {
                    /// 이전 달
                    let day = daysInPrevMonth + dayOffset + 1
                    let date = getDate(for: dayOffset, in: prevMonth)
                    DayCellView(day: day, isSelected: selectedDate == date, isToday: date.formattedCalendarDayDate == today.formattedCalendarDayDate, isCurrentMonth: false)
                        .onTapGesture {
                        }
                } else if dayOffset < daysInMonth {
                    /// 이번 달
                    let date = getDate(for: dayOffset)
                    let day = Calendar.current.component(.day, from: date)
                    DayCellView(day: day, isSelected: selectedDate == date, isToday: date.formattedCalendarDayDate == today.formattedCalendarDayDate, isCurrentMonth: true)
                        .onTapGesture {
                            selectedDate = date
                        }
                } else {
                    /// 다음 달
                    let day = dayOffset - daysInMonth + 1
                    let date = getDate(for: day - 1, in: adjustedMonth(by: 1))
                    DayCellView(day: day, isSelected: selectedDate == date, isToday: date.formattedCalendarDayDate == today.formattedCalendarDayDate, isCurrentMonth: false)
                        .onTapGesture {
                        }
                }
            }
        }
    }
    
    func getDate(for index: Int, in baseMonth: Date) -> Date {
        Calendar.current.date(byAdding: .day, value: index, to: Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: baseMonth))!) ?? Date()
    }
}

// MARK: - Days Cell
private struct DayCellView: View {
    private var day: Int
    private var isSelected: Bool
    private var isToday: Bool
    private var isCurrentMonth: Bool
    
    private var textColor: Color {
        if isSelected {
            return Color.gray900
        } else if isToday {
            return Color.mainBlue
        } else if !isCurrentMonth {
            return Color.gray300
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
        isToday: Bool = false,
        isCurrentMonth: Bool = true
    ) {
        self.day = day
        self.isSelected = isSelected
        self.isToday = isToday
        self.isCurrentMonth = isCurrentMonth
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
