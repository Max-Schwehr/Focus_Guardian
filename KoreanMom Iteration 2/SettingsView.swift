import SwiftUI

struct SettingsView: View {
    var body: some View {
        Form {
            Section(header: Text("General")) {
                Toggle("Enable Notifications", isOn: .constant(true))
                Toggle("Sound Effects", isOn: .constant(false))
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack { SettingsView() }
}
