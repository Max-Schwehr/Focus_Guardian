//
//  FloatingWidowHearts.swift
//  FocusGuardian
//
//  Created by Maximiliaen Schwehr on 12/20/25.
//

import SwiftUI

struct FloatingLivesView: View {
    let totalHearts: Int
    
    private let columns = [
        GridItem(.adaptive(minimum: 20))
    ]
    
    @Binding var size : CGSize
    @Binding var livesLost: Int
    
    @State var test = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Session Lives")
                .bold()
            
            Text("Don't run out of lives!")
                .onAppear {
                    print("Width: \(size.width), Height: \(size.height)")
                    test = true
                }
                .foregroundStyle(.secondary)
            
            
            HStack(spacing: 7) {
                ForEach(0..<totalHearts, id: \.self) { index in
                    let lost = min(livesLost, totalHearts)
                    Text(index < lost ? "💔" : "❤️")
                        .shadow(color: .red.opacity(0.7), radius: 7)
                }
                Spacer()
            }
            .frame(minWidth: 1, minHeight: 1)
            .padding(.top, 3)
        }
        .padding()
        .frame(width: size.width, height: size.height)
        .glassEffect(.clear.interactive(), in: .rect(cornerRadius: 25))
        .transition(
            .scale(scale: 0.0, anchor: .topTrailing)
            .combined(with: .opacity)
            .combined(with:
                    .modifier(
                        active: BlurModifier(radius: 30),
                        identity: BlurModifier(radius: 0)
                    )
            )
        )
    }
    
}


#Preview {
    FloatingLivesView(totalHearts: 8, size: .constant(CGSize(width: 250, height: 100)), livesLost: .constant(3))
}

