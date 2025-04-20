//
//  WaveView.swift
//  DiverBreak
//
//  Created by J on 4/19/25.
//

import SwiftUI

struct WaveView: View {
    let color: Color
    let duration: Double
    let delay: Double

    @State private var offsetY: CGFloat = UIScreen.main.bounds.height

    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: UIScreen.main.bounds.height)
            .offset(y: offsetY)
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.easeOut(duration: duration).delay(delay)) {
                    offsetY = 0
                }
            }
    }
}




#Preview {
    WaveView(color: .customBlue, duration: 2.0, delay: 0.0)
}
