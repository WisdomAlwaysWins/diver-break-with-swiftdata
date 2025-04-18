//
//  ParticipantRepository.swift
//  DiverBreak
//
//  Created by J on 4/16/25.
//

import Foundation

final class ParticipantRepository : ObservableObject {
    // 현재 추가된 참가자 목록
    
    @Published private(set) var participants: [Participant] = []
    
    // 참가자 추가
    func add(_ participant: Participant) {
        participants.append(participant)
    }
    
    // 참가자 삭제
    func remove(_ participant: Participant) {
        participants.removeAll { $0.id == participant.id }
    }
    
    // 참가자 수정 (이름 또는 역할)
    func update(_ participant: Participant) {
        guard let index = participants.firstIndex(where: { $0.id == participant.id }) else { return }
        participants[index] = participant
    }

    // 전체 초기화 (새 회의 시작 등)
    func clearAll() {
        participants.removeAll()
    }

    // 이름 중복 검사
    func isNameDuplicated(_ name: String) -> Bool {
        participants.contains { $0.name.trimmingCharacters(in: .whitespacesAndNewlines) == name }
    }
    
}
