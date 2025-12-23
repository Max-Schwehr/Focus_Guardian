import SwiftUI
import SwiftData

struct SessionsView: View {
    @Query var sessions: [FocusSession]
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
        VStack(spacing: 16) {
            List {
                ForEach(groupedSessions, id: \.date) { group in
                    Section(header: Text(dayHeaderFormatter.string(from: group.date)).font(.headline)) {
                        ForEach(group.items) { session in
                            SessionCell(session: session)
                                .listRowSeparator(.hidden)
                        }
                        .onDelete { offsets in
                            deleteSessions(in: group.items, at: offsets)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .padding()
        .navigationTitle("Sessions")
    }
}

extension SessionsView {
    // Delete using offsets within a specific grouped subset, mapping back to the original sessions array
    private func deleteSessions(in subset: [FocusSession], at offsets: IndexSet) {
        // Build a set of IDs to delete based on the subset and offsets
        let idsToDelete: Set<PersistentIdentifier> = Set(offsets.compactMap { idx in
            subset[idx].persistentModelID
        })

        // Find matching sessions in the full collection and delete them
        for session in sessions where idsToDelete.contains(session.persistentModelID) {
            modelContext.delete(session)
        }

        do {
            try modelContext.save()
        } catch {
            print("Failed to delete sessions: \(error)")
        }
    }
}

#Preview {
    NavigationStack { SessionsView() }
}
