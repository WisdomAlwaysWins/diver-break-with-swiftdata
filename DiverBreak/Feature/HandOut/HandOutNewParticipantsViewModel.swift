//
//  HandOutNewParticipantsViewModel.swift
//  DiverBreak
//
//  Created by J on 4/19/25.
//

import Foundation
import SwiftData

class HandOutNewParticipantsViewModel : ObservableObject {
    @Published var participants: [Participant] = []
    @Published var newNames: [String] = []
    @Published var currentIndex = 0
    @Published var isRevealed = false
    
    func setParticipants(_ participants: [Participant]) {
        self.participants = participants.sorted { $0.name < $1.name }
        self.currentIndex = 0
        self.isRevealed = false
    }

    func currentParticipant() -> Participant? {
        participants.indices.contains(currentIndex) ? participants[currentIndex] : nil
    }

    func currentRole() -> Role? {
        guard let name = currentParticipant()?.assignedRoleName else { return nil }
        return RoleCardProvider.role(named: name)
    }

    func goToNext() {
        if currentIndex < participants.count - 1 {
            currentIndex += 1
            isRevealed = false
        }
    }

    func isLastParticipant() -> Bool {
        currentIndex >= participants.count - 1
    }
}
