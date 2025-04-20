//
//  WaveLayer.swift
//  DiverBreak
//
//  Created by J on 4/19/25.
//

import SwiftUI

struct WaveLayer: View {
    var color: Color
    var amplitude: CGFloat
    var speed: Double
    var offset: Double
    var duration: Double

    @State private var phase: CGFloat = 0
    @State private var yOffset: CGFloat = UIScreen.main.bounds.height

    var body: some View {
        GeometryReader { geo in
            WaveShape(phase: phase, amplitude: amplitude)
                .fill(color)
                .frame(height: geo.size.height * 2.0)
                .offset(y: yOffset)
                .onAppear {
                    withAnimation(.easeOut(duration: duration).delay(offset)) {
                        yOffset = 0
                    }
                    withAnimation(Animation.linear(duration: speed).repeatForever(autoreverses: false)) {
                        phase = .pi * 5.5
                    }
                }
        }
    }
}

#Preview {
    WaveLayer(color: .blue, amplitude: 20, speed: 2, offset: 0, duration: 0.0)
}
