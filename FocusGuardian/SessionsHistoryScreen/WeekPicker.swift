//
//  WeekPicker.swift
//  FocusGuardian
//
//  Created by Maximiliaen Schwehr on 1/3/26.
//

import SwiftUI


struct WeekPicker: View {
    @State private var selectedDate: Date = Date()
    
    var body: some View {
        HStack() {
            Button {
                withAnimation {
                    print("Left Button Pressed")
                    if let newDate = Calendar.mondayFirst.date(byAdding: .weekOfYear, value: -1, to: selectedDate) {
                        selectedDate = newDate
                    }
                }
            } label: {
                Image(systemName: "chevron.left")
                    .padding(10)
                    .contentShape(Circle())
            }
            .padding(0)
            .buttonStyle(.plain)
            .glassEffect(.regular)
            
            Text(weekLabel(for: selectedDate))
                .contentTransition(.numericText())
                .frame(width: 110)
                .padding(10)
                .glassEffect()
            
            Button {
                withAnimation {
                    print("Right Button Pressed")
                    if let newDate = Calendar.mondayFirst.date(byAdding: .weekOfYear, value: 1, to: selectedDate) {
                        selectedDate = newDate
                    }
                }
            } label: {
                Image(systemName: "chevron.right")
                    .padding(10)
                    .contentShape(Circle())
            }
            .padding(0)
            .buttonStyle(.plain)
            .glassEffect(.regular)
        }
    }
}

#Preview {
    WeekPicker()
}

extension Calendar {
    static var mondayFirst: Calendar = {
        var cal = Calendar(identifier: .gregorian)
        cal.firstWeekday = 2 // Monday = 2, Sunday = 1 in Gregorian
        cal.minimumDaysInFirstWeek = 4 // ISO-like behavior (optional)
        return cal
    }()
}

private func weekBounds(containing date: Date, calendar: Calendar = .mondayFirst) -> (monday: Date, sunday: Date)? {
    guard let monday = calendar.dateInterval(of: .weekOfYear, for: date)?.start,
          let sunday = calendar.date(byAdding: .day, value: 6, to: monday) else {
        return nil
    }
    return (monday, sunday)
}

private func weekLabel(for date: Date, calendar: Calendar = .mondayFirst) -> String {
    guard let (monday, sunday) = weekBounds(containing: date, calendar: calendar) else { return "" }
    let formatter = DateFormatter()
    formatter.calendar = calendar
    formatter.locale = .current
    formatter.setLocalizedDateFormatFromTemplate("MMM d")
    let start = formatter.string(from: monday)
    let end = formatter.string(from: sunday)
    return "\(start) – \(end)"
}
