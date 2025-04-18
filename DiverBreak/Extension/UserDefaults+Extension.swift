//
//  UserDefaults+Extension.swift
//  DiverBreak
//
//  Created by J on 4/17/25.
//

import Foundation

extension UserDefaults {
    var hasInsertedRoles: Bool {
        get { bool(forKey: "hasInsertedRoles") }
        set { set(newValue, forKey: "hasInsertedRoles") }
    }
}
