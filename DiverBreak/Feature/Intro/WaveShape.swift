//
//  WaveShape.swift
//  DiverBreak
//
//  Created by J on 4/19/25.
//

import SwiftUI

struct WaveShape: Shape {
    var phase: CGFloat
    var amplitude: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height

        path.move(to: CGPoint(x: 0, y: height))

        for x in stride(from: 0, through: width, by: 1) {
            let relativeX = x / width
            let sine = sin(relativeX * .pi * 1 + phase)
            let y = amplitude * sine + 40
            path.addLine(to: CGPoint(x: x, y: y))
        }

        path.addLine(to: CGPoint(x: width, y: height))
        path.closeSubpath()

        return path
    }

    var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }
}

#Preview {
    WaveShape(phase: 0, amplitude: 20)
}
