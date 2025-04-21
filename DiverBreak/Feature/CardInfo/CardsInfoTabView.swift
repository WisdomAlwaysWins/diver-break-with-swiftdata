//
//  CardsInfoTabView.swift
//  DiverBreak
//
//  Created by J on 4/20/25.
//

import SwiftUI

struct CardsInfoTabView: View {
    @StateObject private var viewModel = CardsInfoTabViewModel()

    var body: some View {
        TabView(selection: $viewModel.currentIndex) {
            ForEach(viewModel.cards.indices, id: \.self) { index in
                ZStack {
                    fullScreenImage(name: viewModel.cards[index])

//                    nextButton
//                        .padding(.top)
//                        .frame(maxWidth: .infinity, alignment: .center)
                    
                }
                .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .ignoresSafeArea() // 탭뷰 자체도 safe area 무시
    }

    private func fullScreenImage(name: String) -> some View {
        Image(name)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(Color.black.opacity(0.01))
            .ignoresSafeArea(edges: [.top, .bottom])
    }

    private var nextButton: some View {
        Button(action: {
            viewModel.goToNext()
        }) {
            Image(systemName: "chevron.right")
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .bold))
                .frame(width: 77, height: 77)
                .background(Color(.customYellow))
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
        }
    }
}
#Preview {
    CardsInfoTabView()
}
