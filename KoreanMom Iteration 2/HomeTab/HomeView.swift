import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 16) {
            SessionOnboardingView()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(.ultraThinMaterial)
        .ignoresSafeArea()
        .navigationTitle("")
        .scrollContentBackground(.hidden)
        .background(.clear)
    }
}

#Preview {
    NavigationStack { HomeView() }
}
