//
//  TimerCompletedView.swift
//  FocusGuardian
//
//  Created by Maximiliaen Schwehr on 12/23/25.
//

import SwiftUI

struct TimerCompletedView: View {
    @Binding var size : CGSize
    @Binding var isCountingDown : Bool
    let onAddTime: () -> Void
    var body: some View {
        VStack {
            Text("Session Complete!").bold()
            Text("Add more time, or end the session!")
                .padding(.bottom, 4)
                .foregroundStyle(.secondary)
            
            HStack {
                Button {
                    onAddTime()
                } label: {
                    Label("Add Time", systemImage: "plus.circle")
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(
                            Capsule().fill(Color(.systemFill))
                        )
                }
                .buttonStyle(.plain)
                
                Button {
                    
                } label: {
                    Label("End Session", systemImage: "checkmark.circle")
                        .foregroundStyle(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(
                            Capsule().fill(Color.blue)
                        )
                }
                .buttonStyle(.plain)

            }
        }
        .frame(width: size.width, height: size.height)

    }
}

#Preview {
    TimerCompletedView(size: .constant(CGSize(width: 300, height: 100)), isCountingDown: .constant(true), onAddTime: {})
        .padding()
}
