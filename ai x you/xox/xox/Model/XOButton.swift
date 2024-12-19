//
//  XOButton.swift
//  xox
//
//  Created by tunc on 17.10.2024.
//

import SwiftUI

struct XOButton: View {
    
    @Binding var letter: String
    @State private var degrees = 0.0
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 120, height: 120)
                .foregroundColor(.blue)
            
            Circle()
                .frame(width: 100, height: 100)
                .foregroundColor(.white)
            
            Text(letter)
                .font(.system(size: 50))
                .bold()
        }
        .rotation3DEffect(
            .degrees(degrees),
            axis: (x: 1, y: 0, z: 0)
        )
        .simultaneousGesture(
            TapGesture()
                .onEnded { _ in
                    withAnimation(.easeIn(duration: 0.25)) {
                        self.degrees -= 180 
                    }
                }
        )
    }
}

struct XOButton_Preview: PreviewProvider {
    
    static var previews: some View {
        XOButton(letter: .constant("x"))
    }
}
