//
//  FloatingWidowHearts.swift
//  FocusGuardian
//
//  Created by Maximiliaen Schwehr on 12/20/25.
//

import SwiftUI

struct FloatingWindowHearts: View {
    
    let data = (1...20).map { "Item \($0)" }
    
    let columns = [
        GridItem(.adaptive(minimum: 20))
    ]
    
    @Binding var size : CGSize
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("Session Lives")
                .bold()
            
            Text("Don't run out of lives!")
            
            LazyVGrid(columns: columns, spacing: 7) {
                ForEach(data, id: \.self) { item in
                    Image(systemName: "heart.fill")
                    
                }
            }
            .padding(.top, 10)
            .onAppear {
                let minItemWidth: CGFloat = 20
                let spacing: CGFloat = 7
                let padding: CGFloat = 16 // matches .padding() default
                let cols = columnCount(containerWidth: size.width,
                                       minItemWidth: minItemWidth,
                                       horizontalSpacing: spacing,
                                       horizontalPadding: padding)
                let rows = rowCount(itemCount: data.count, columns: cols)
                print("Vertically stacked hearts (rows): \(rows)")
                
                let heightToIncreaseBy = CGFloat((rows-1) * 20)
                print("Height to Increase By: \(heightToIncreaseBy)")
                
                size.height += heightToIncreaseBy // Note: This value will not be able to increase in the Xcode preview, but will work in the real app
                
            }
        }
        .padding()
        .glassEffect(.clear.interactive())
        .frame(width: size.width, height: size.height)
        
    }
    private func columnCount(containerWidth: CGFloat, minItemWidth: CGFloat, horizontalSpacing: CGFloat, horizontalPadding: CGFloat) -> Int {
        let available = max(0, containerWidth - 2 * horizontalPadding)
        let count = Int(floor((available + horizontalSpacing) / (minItemWidth + horizontalSpacing)))
        return max(count, 1)
    }
    
    private func rowCount(itemCount: Int, columns: Int) -> Int {
        guard columns > 0 else { return itemCount }
        return Int(ceil(Double(itemCount) / Double(columns)))
    }
}

#Preview {
    FloatingWindowHearts(size: .constant(CGSize(width: 250, height: 100)))
    
}

