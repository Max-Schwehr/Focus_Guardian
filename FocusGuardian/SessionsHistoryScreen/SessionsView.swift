import SwiftUI
import SwiftData

struct SessionsView: View {
    @Query(sort: [SortDescriptor(\FocusSession.date)]) var sessions: [FocusSession]
    @Environment(\.modelContext) var modelContext
    
    
    private var dayHeaderFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .full
        df.timeStyle = .none
        return df
    }
    
    var body: some View {
        VStack(spacing: 0) {
            WeekPicker()
                .padding(.horizontal)
                .padding(.top)

            if sessions.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "tray")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                    Text("No sessions yet")
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(sessions, id: \.self) { session in
                        SessionCell(session: session)
                            .listRowInsets(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                    }
                }
                .listStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial)
        .navigationTitle("Sessions")
    }
}

#Preview {
    ContentView(selection: .sessions)
        .frame(width: 505, height: 550)
        .background(.gray.opacity(0.1))
    
}

