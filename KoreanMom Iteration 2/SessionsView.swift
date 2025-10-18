import SwiftUI

struct SessionsView: View {
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
        }
        .padding()
        .navigationTitle("Sessions")
    }
}

#Preview {
    NavigationStack { SessionsView() }
}
