//
//  HandOutViewModel.swift
//  DiverBreak
//
//  Created by J on 4/17/25.
//

import Foundation
import SwiftUI
import SwiftData

class HandOutCardViewModel: ObservableObject {
    
    @Published var participants: [Participant] = []
    
    private var context: ModelContext?
    
    func setContext(_ context: ModelContext) {
        self.context = context
        
        loadParticipants()
    }
    
    @Published var currentIndex = 0
    @Published var isRevealed = false
    
    // MARK: - UI 로직
    func currentParticipant() -> Participant? {
        guard participants.indices.contains(currentIndex) else { return nil }
        return participants[currentIndex]
    }

    func currentRole() -> Role? {
        guard let name = currentParticipant()?.assignedRoleName else { return nil }
        return RoleCardProvider.role(named: name)
    }

    func handleConfirm(pathModel: PathModel) {
        if isLastParticipant() {
            pathModel.resetTo(.main)
        } else {
            goToNext()
        }
    }
    
    func isLastParticipant() -> Bool {
        return currentIndex == participants.count - 1
    }

    func goToNext() {
        if !isLastParticipant() {
            currentIndex += 1
        }
        isRevealed = false
    }
    
    // MARK: - 데이터 불러오기
    func loadParticipants() {
        guard let context else {
            print("❌ context가 설정되지 않음")
            return
        }

        do {
            let fetchedAll = try context.fetch(FetchDescriptor<Participant>())
            self.participants = fetchedAll.sorted { $0.name < $1.name } // 이름 순서대로 정렬
            print("✅ 참가자 불러오기 성공: \(fetchedAll.count)명")
        } catch {
            print("❌ 참가자 불러오기 실패: \(error)")
        }
    }
    
    
    
    
    
}
