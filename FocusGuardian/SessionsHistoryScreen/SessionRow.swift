import SwiftUI

struct SessionRow: View {
    let systemImage: String
    let title: String
    let timeText: String

    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .fontWeight(.medium)
            Text(title)
                .fontWeight(.medium)
            Text(timeText)
            Spacer()
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.white.opacity(0.6))
        )
    }
}

#Preview {
    VStack(spacing: 10) {
        SessionRow(systemImage: "briefcase", title: "Work:", timeText: "50 min")
        SessionRow(systemImage: "bed.double", title: "Break:", timeText: "10 min")
        SessionRow(systemImage: "ellipsis.circle", title: "Add-on", timeText: "20 min")
    }
    .padding()
    .background(.gray.opacity(0.1))
}
