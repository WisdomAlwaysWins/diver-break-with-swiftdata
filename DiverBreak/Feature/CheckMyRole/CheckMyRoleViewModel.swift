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
    
    func setContext(_ context: ModelContext) {
        self.context = context
    }
}
