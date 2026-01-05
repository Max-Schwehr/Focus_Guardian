import Foundation

public let sampleFocusSessions: [FocusSession] = [
    FocusSession(
        completedLength: 130,
        date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
        totalHeartsCount: 3,
        problemOccurred: false,
        sections: [
            FocusSection(length: 50, isFocusSection: true),
            FocusSection(length: 10, isFocusSection: false),
            FocusSection(length: 50, isFocusSection: true)
        ]
    ),
    FocusSession(
        completedLength: 70,
        date: Date(),
        totalHeartsCount: 3,
        problemOccurred: false,
        sections: [
            FocusSection(length: 50, isFocusSection: true)
        ]
    ),
    FocusSession(
        completedLength: 95,
        date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(),
        totalHeartsCount: 2,
        problemOccurred: true,
        sections: [
            FocusSection(length: 25, isFocusSection: true),
            FocusSection(length: 5, isFocusSection: false),
            FocusSection(length: 25, isFocusSection: true),
            FocusSection(length: 5, isFocusSection: false),
            FocusSection(length: 25, isFocusSection: true)
        ]
    )
]
