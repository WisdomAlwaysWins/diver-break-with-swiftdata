//
//  CardsInfoTabViewModel.swift
//  DiverBreak
//
//  Created by J on 4/20/25.
//

import Foundation

class CardsInfoTabViewModel : ObservableObject {
    
    // 이미지 이름 배열
    let cards = [
        "disccard",
        "energycard",
        "flowcard",
        "jokercard",
        "metimecard",
        "oxygencard",
        "spacecard"
    ]

    // 현재 탭 인덱스
    @Published var currentIndex: Int = 0

    // 다음 카드로 이동
    func goToNext() {
        if currentIndex < cards.count - 1 {
            currentIndex += 1
        } else {
            currentIndex = 0 // 마지막이면 처음으로
        }
    }

    // 현재 카드 이미지 이름
    var currentCardName: String {
        cards[currentIndex]
    }

    // 마지막 카드인지 확인
    var isLastCard: Bool {
        currentIndex == cards.count - 1
    }
}
