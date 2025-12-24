//
//  TimerCompletedView.swift
//  FocusGuardian
//
//  Created by Maximiliaen Schwehr on 12/23/25.
//

import SwiftUI

struct TimerCompletedView: View {
    @Binding var size : CGSize
    var body: some View {
        VStack {
            Text("Session Complete!").bold()
            Text("Add more time, or end the session!")
                .padding(.bottom, 5)
            HStack {
                Button {
                    
                } label: {
                    Label("Add Time", systemImage: "plus.circle")
                        .contentShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.plain)
                .glassEffect()
                
                Button {
                    
                } label: {
                    Label("End Session", systemImage: "checkmark.circle")
                        .contentShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .foregroundStyle(.white)
                }
                .glassEffect(.regular.tint(.blue))
                .buttonStyle(.plain)
                .glassEffect()

            }
        }
//        .glassEffect(.clear.interactive(), in: .rect(cornerRadius: 25))
        .frame(width: size.width, height: size.height)

    }
}

#Preview {
    TimerCompletedView(size: .constant(CGSize(width: 300, height: 100)))
        .padding()
}
