//
//  MyRoleView.swift
//  DiverBreak
//
//  Created by J on 4/19/25.
//

import SwiftUI

struct MyRoleView: View {
    let name: String
    let onLongPressCompleted: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(name)
                .font(.headline)
                .fontWeight(.semibold)

            Text("👇🏻 길게 눌러 확인")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .aspectRatio(1, contentMode: .fit)
        .background(.white)
        .cornerRadius(8)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.diverGray0, lineWidth: 1)
        }
        .contentShape(Rectangle())
        .onLongPressGesture(minimumDuration: 0.8) {
            HapticManager.success()
            onLongPressCompleted()
        }
    }
}

#Preview {
    MyRoleView(name: "제이") {
        print("👆🏻 역할 확인")
    }
}
