//
//  FloatingWidowHearts.swift
//  FocusGuardian
//
//  Created by Maximiliaen Schwehr on 12/20/25.
//

import SwiftUI

struct FloatingWindowHearts: View {
    let totalHearts: Int
    
    private let columns = [
        GridItem(.adaptive(minimum: 20))
    ]
    
    @Binding var size : CGSize
    @Binding var livesLost: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Session Lives")
                .bold()
            
            Text("Don't run out of lives!")
            
            LazyVGrid(columns: columns, spacing: 7) {
                ForEach(0..<totalHearts, id: \.self) { index in
                    let lost = min(livesLost, totalHearts)
                    Image(systemName: index < lost ? "heart.slash.fill" : "heart.fill")
                }
            }
            .padding(.top, 9)
            
        }
        .padding()
        .glassEffect(.clear.interactive(), in: .rect(cornerRadius: 25))
        .frame(width: size.width, height: size.height)
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

func getFloatingHeartsWindowHeight(numberOfHearts: Int) -> Int {
    let numberOfRows : Int = Int(ceil(Double(numberOfHearts) / 8))
    return 100 + numberOfRows * 10
}


#Preview {
    FloatingWindowHearts(totalHearts: 8, size: .constant(CGSize(width: 250, height: 100)), livesLost: .constant(3))
}

