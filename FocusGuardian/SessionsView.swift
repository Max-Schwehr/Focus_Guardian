import SwiftUI
import SwiftData

struct SessionsView: View {
    @Query var sessions: [FocusSession]
    @Environment(\.modelContext) var modelContext

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "list.bullet")
                .font(.system(size: 48, weight: .regular))
                .symbolRenderingMode(.hierarchical)
            Text("Sessions")
                .font(.largeTitle)
                .bold()
            Text("Review and manage your focus sessions")
                .foregroundStyle(.secondary)
            
            List {
                ForEach(sessions) { session in
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Target: \(session.targetLength) min")
                                .font(.headline)
                            Spacer()
                            Label(session.completed ? "Completed" : "In Progress",
                                  systemImage: session.completed ? "checkmark.circle.fill" : "clock")
                                .foregroundStyle(session.completed ? .green : .orange)
                                .font(.subheadline)
                        }
                    }
                }
                .onDelete(perform: deleteSessions)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .padding()
        .navigationTitle("Sessions")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Add Sample Data") {
                    addSampleData()
                }
            }
        }
    }
}

extension SessionsView {
    private func addSampleData() {
        let now = Date()
        let sampleSessions: [FocusSession] = [
            FocusSession(targetLength: 25, completed: true, date: now.addingTimeInterval(-3600*3)),
            FocusSession(targetLength: 45, completed: false, date: now.addingTimeInterval(-3600*6)),
            FocusSession(targetLength: 20, completed: true, date: now.addingTimeInterval(-3600*1))
        ]
        
        for session in sampleSessions {
            modelContext.insert(session)
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save sample sessions: \(error)")
        }
    }
    
    private func deleteSessions(at offsets: IndexSet) {
        for index in offsets {
            let session = sessions[index]
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
