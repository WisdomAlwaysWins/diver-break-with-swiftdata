//
//  MyRoleView.swift
//  DiverBreak
//
//  Created by J on 4/19/25.
//

import SwiftUI

struct MyRoleView: View {
    let name: String
    let roleName: String?
    let roleGuide: String
    
    @State var isRevealed: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(name)
                .font(.title3)
                .fontWeight(.semibold)
            
            if isRevealed {
                Text(roleName ?? "역할 없음")
                    .font(.headline)
                    .foregroundColor(.customBlue)
                Text(roleGuide)
                    .font(.caption)
                    .foregroundColor(.gray)
            } else {
                Text("✔️ 길게 눌러 확인")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.background)
        .aspectRatio(1, contentMode: .fit)
        .cornerRadius(8)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.diverGray0, lineWidth: 1)
        }
        .contentShape(Rectangle())
        .onLongPressGesture(minimumDuration: 2.0) {
            isRevealed = true
        } onPressingChanged: { pressing in
            if !pressing {
                isRevealed = false
            }
        }
    }
}

#Preview {
    @State var revealed = false
    
    MyRoleView(
        name: "제이",
        roleName: "에너지 체커",
        roleGuide: "이렇게 저렇게"
    )
}
