import SwiftUI
import SwiftData

struct SessionsView: View {
    @Query(sort: [SortDescriptor(\FocusSession.date)]) var sessions: [FocusSession]
    @Environment(\.modelContext) var modelContext
    
    @State private var filteredSessions : [FocusSession] = []
    
    private var dayHeaderFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .full
        df.timeStyle = .none
        return df
    }
    
    private func filterSessions() {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: filterStartDate)
        // Compute end of day by taking the start of the next day and subtracting 1 second
        let startOfNextEndDay = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: filterEndDate))!
        let endOfDay = startOfNextEndDay.addingTimeInterval(-1)

        let range: ClosedRange<Date> = startOfDay...endOfDay
        filteredSessions = sessions.filter { range.contains($0.date) }
    }
    
    @State private var filterStartDate = Date()
    @State private var filterEndDate = Date()
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                // MARK: - No Focus Sessions Indicator
                if sessions.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "tray")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                        Text("No sessions yet")
                            .foregroundStyle(.secondary)
                    }
                } else {
                    // MARK: - Focus Session List
                    VStack(spacing: 10) {
                        ForEach(filteredSessions, id: \.self) { session in
                            SessionCell(session: session)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.top, 50)
                    
                }
            }
            // MARK: - Focus Session List Fade On Top
            .mask {
                VStack {
                    LinearGradient(colors: [Color.white, Color.clear], startPoint: .bottom, endPoint: .top)
                        .frame(height: 60)
                expansivePlane
                        .background(Color.white)
                }
            }
            
            // MARK: - Week Picker
            WeekPicker(startDate: $filterStartDate, endDate: $filterEndDate)
                .padding(.horizontal)
                .padding(.bottom)

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial)
        .navigationTitle("Sessions")
        .onAppear(perform: filterSessions) // Filter the sessions when the UI is rendered
        .onChange(of: filterStartDate, filterSessions) // Re-filter the sessions if the start / end dates change
    }
}

#Preview {
    let container: ModelContainer = {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: FocusSession.self, configurations: config)
        for _ in 1..<3 {
            let session = FocusSession(
                completedLength: 100,
                date: Date(),
                totalHeartsCount: 3,
                problemOccurred: false,
                sections: [
                    FocusSection(length: 30, isFocusSection: true)
                ]
            )
            container.mainContext.insert(session)
        }
        return container
    }()
    
    return SessionsView()
        .modelContainer(container)
        .frame(width: 505, height: 550)
        .background(.gray.opacity(0.1))
}
