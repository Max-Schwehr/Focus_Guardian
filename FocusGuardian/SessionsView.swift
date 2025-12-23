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
    }
}

extension SessionsView {
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
