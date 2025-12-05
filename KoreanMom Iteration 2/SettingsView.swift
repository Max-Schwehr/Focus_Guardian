import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Head Tracking").bold()
            Text("Use secure on device head tracking to make sure your focused.")
            
            FaceRotationChart()
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .foregroundStyle(Color(.gray))
                        .opacity(0.1)
                )
                
        
        }
            .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack { SettingsView().padding() }
}
