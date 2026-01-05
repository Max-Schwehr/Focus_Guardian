import SwiftUI

struct SectionCell: View {
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
                .fill(Color("StandardBackgroundColor").opacity(0.6))
        )
    }
}

#Preview {
    VStack(spacing: 10) {
        SectionCell(systemImage: "briefcase", title: "Work:", timeText: "50 min")
        SectionCell(systemImage: "bed.double", title: "Break:", timeText: "10 min")
        SectionCell(systemImage: "ellipsis.circle", title: "Add-on", timeText: "20 min")
    }
    .padding()
    .background(.gray.opacity(0.1))
}
