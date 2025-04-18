//
//  RoleCardView.swift
//  DiverBreak
//
//  Created by J on 4/18/25.
//

import SwiftUI

struct RoleCardView: View {
    let name: String
    let roleName: String?
    let imageName : String?
    
    @Binding var isRevealed: Bool

    var body: some View {
        
        VStack {
            ZStack {
                if isRevealed { // 누름
                    roleImage(for : imageName)
                } else { // 안누름
                    ZStack {
                        roleImage(for: "cardbackground")
                        
                        VStack(spacing: 24) {
                            Image("goggle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: UIScreen.main.bounds.width * 0.25)

                            Text(name)
                                .font(.largeTitle)
                                .fontWeight(.black)
                                .foregroundColor(.white)

                            Text("2초간 누르면 역할이 공개됩니다")
                                .font(.subheadline)
                                .foregroundColor(.white)
                        }
                    }
                    .onLongPressGesture(minimumDuration: 0.5) { // TODO: - 시간바꾸기
//                        print("PRESS")
                        withAnimation {
                            isRevealed = true
                        }
                    }
                }
            }
        }
    }
    
    private func roleImage(for imageName: String?) -> some View {
        guard let imageName = imageName else {
            return AnyView(
                Text("❌ 이미지 없음")
                    .foregroundColor(.red)
            )
        }
        
        return AnyView(
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width * 0.9)
        )
    }
}

#Preview {
    @State var revealed = false

    return RoleCardView(
        name: "제이",
        roleName: "에너지 체커",
        imageName: "energychecker",
        isRevealed: $revealed
    )
}

