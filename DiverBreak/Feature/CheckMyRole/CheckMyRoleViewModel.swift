//
//  CheckMyRoleViewModel.swift
//  DiverBreak
//
//  Created by J on 4/19/25.
//

import Foundation
import SwiftData

@MainActor
class CheckMyRoleViewModel: ObservableObject {
    private var context: ModelContext?

    @Published var selectedRole: SelectedRoleData? = nil

    func setContext(_ context: ModelContext) {
        self.context = context
    }

    func roleFor(participant: Participant) -> Role? {
        guard let roleName = participant.assignedRoleName else { return nil }
        return RoleCardProvider.role(named: roleName)
    }

    func selectRole(for participant: Participant) {
        if let role = roleFor(participant: participant) {
            selectedRole = SelectedRoleData(name: participant.name, image: role.fullScreenImageName)
        }
    }
}

struct SelectedRoleData: Identifiable, Equatable {
    var id: UUID = UUID()
    let name: String
    let image: String
}

