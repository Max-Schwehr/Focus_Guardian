import SwiftUI
import SwiftData

struct SessionsView: View {
    @Query(sort: [SortDescriptor(\FocusSession.date)]) var sessions: [FocusSession]
    @Environment(\.modelContext) var modelContext
    
    // Group sessions by calendar day, newest day first, sessions within each day sorted by time descending
    private var groupedSessions: [(date: Date, items: [FocusSession])] {
        let calendar = Calendar.current
        let groups = Dictionary(grouping: sessions) { session in
            calendar.startOfDay(for: session.date)
        }
        // sort days descending, and items within each day descending by date
        return groups
            .map { (key, value) in
                (date: key, items: value.sorted { $0.date > $1.date })
            }
            .sorted { $0.date > $1.date }
    }
    
    private var dayHeaderFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .full
        df.timeStyle = .none
        return df
    }
    
    var body: some View {
        ZStack {
            //MARK: Scroll View
            VStack(spacing: 16) {
                ScrollView {
                    ForEach(groupedSessions, id: \.date) { group in
                        // MARK: Section Header
                        Section(header:
                                    HStack {
                            Text(dayHeaderFormatter.string(from: group.date)).font(.headline)
                                .padding(.top)
                            Spacer()
                        }
                        ){
                            ForEach(group.items) { session in
                                // MARK: Scroll View Cells
                                SessionCell(session: session)
                                    .listRowSeparator(.hidden)
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)
                .scrollClipDisabled()
                .listStyle(.plain)
            }
            .padding()
            
            //MARK: Fade on the top and bottom of the window
            VStack {
                LinearGradient(colors: [.white, .clear], startPoint: .top, endPoint: .bottom)
                    .frame(height: 30)
                Spacer()
                LinearGradient(colors: [.clear, .white], startPoint: .top, endPoint: .bottom)
                    .frame(height: 30)
            }
                .ignoresSafeArea()
            
            
        }
        .navigationTitle("Sessions")
    }
}

#Preview("SessionsView with Mock Data") {
    // Build an in-memory container for previews
    let schema = Schema([FocusSession.self])
    let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: schema, configurations: [configuration])
    
    // Insert some mock sessions
    let now = Date()
    let samples = FocusSession.mockSamples(now: now)
    for s in samples { container.mainContext.insert(s) }
    try! container.mainContext.save()
    
    return NavigationStack { SessionsView() }
        .modelContainer(container)
}
