//
//  MainViewModel.swift
//  DiverBreak
//
//  Created by J on 4/18/25.
//

import SwiftUI
import SwiftData

class MainViewModel: ObservableObject {
    
    @Published var participants: [Participant] = []
    @Published var jokerParticipantName: String? = ""
    @Published var isJokerRevealed = false
    
    private var context: ModelContext?
    
    func setContext(_ context: ModelContext) {
        self.context = context
        
        loadParticipants()
    }
    
    // MARK: - 데이터 불러오기
    func loadParticipants() {
        guard let context else {
            print("❌ context가 설정되지 않음")
            return
        }

        do {
            let fetchedAll = try context.fetch(FetchDescriptor<Participant>())
            self.participants = fetchedAll.sorted { $0.name < $1.name }
            
            self.jokerParticipantName = fetchedAll.first { $0.assignedRoleName == "조커" }?.name
            
            print("✅ 참가자 불러오기 성공: \(fetchedAll.count)명")
        } catch {
            print("❎ 참가자 불러오기 실패: \(error)")
        }
    }
    
    
}

