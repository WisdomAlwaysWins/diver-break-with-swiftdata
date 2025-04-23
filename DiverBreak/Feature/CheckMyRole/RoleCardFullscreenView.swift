//
//  RoleCardFullscreenView.swift
//  DiverBreak
//
//  Created by J on 4/20/25.
//

import SwiftUI

struct RoleCardFullscreenView: View {
    let name: String
    let fullscreenImageName: String
//    let onClose: () -> Void // 얘는 왜? 클로저...?

    var body: some View {
        ZStack {
            Color.clear
                .ignoresSafeArea()
            
            Image(fullscreenImageName)
                .resizable()
                .scaledToFill()
        }
    }
}

#Preview {
    RoleCardFullscreenView(name: "제이", fullscreenImageName: "metimecard")
}
