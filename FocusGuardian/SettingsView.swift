import SwiftUI

struct SettingsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                VStack(alignment: .leading) {
                    
                    Text("Session History").bold()
                    
                    
                    Toggle("Delete 30 day old sessions", isOn: .constant(false))
                        .toggleStyle(.switch)
                    
                    
                    
                }
                .padding(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                
                VStack(alignment: .leading) {
                    
                    Text("Head Tracking").bold()
                    Text("We use secure on device head tracking to make sure your focused.")
                    
                    FaceRotationChart()
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .foregroundStyle(Color(.gray))
                                .opacity(0.1)
                        )
                }
                .padding(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                
                VStack(alignment: .leading) {
                    Text("Privacy Policy & Terms of Service")
                        .bold()
                    Text("TLDR; Focus Guardian respect your privacy, no data is tracked, linked to you, or ever touches servers on the internet for processing. Everything stays on your Mac!")
                }
                .padding(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                
                
            }
            .padding()
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    NavigationStack { SettingsView().padding() }
        .frame(width: 500)
}
