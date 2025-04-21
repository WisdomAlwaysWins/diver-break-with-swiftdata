//
//  SplashView.swift
//  DiverBreak
//
//  Created by J on 4/19/25.
//

import SwiftUI

struct SplashView: View {
    @Binding var isActive : Bool

    var body: some View {
        ZStack {
            
            Color.white.ignoresSafeArea()
            
            WaveLayer(color: .customWaveLight, amplitude: 40, speed: 3, offset: 0, duration: 1.5)
                .padding(.top, -70)
            WaveLayer(color: .customWaveDark, amplitude: 30, speed: 2, offset: 0.3, duration: 1.5)
                .padding(.top, -70)
            
            VStack {
                Text("DIVER\nBREAK")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                
                Text("SHOUT OUT TO SNOW AND DAIN")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.bottom, 24)
            }
            
            

        }
        .ignoresSafeArea()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                isActive = false
            }
        }
    }
}

#Preview {
    SplashView(isActive: .constant(false))
}
