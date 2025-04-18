//
//  Participant.swift
//  DiverBreak
//
//  Created by J on 4/16/25.
//

import Foundation
import SwiftData

@Model
class Participant { 
    @Attribute(.unique) var id: UUID
    var name: String
    var assignedRoleName: String?
    
    var assignedRole: Role? {
        guard let name = assignedRoleName else { return nil }
        return RoleCardProvider.role(named: name)
    }

    init(name: String, assignedRoleName: String? = nil) {
        self.id = UUID()
        self.name = name
        self.assignedRoleName = assignedRoleName
    }
    
}
