//
//  Role.swift
//  DiverBreak
//
//  Created by J on 4/16/25.
//

import SwiftData
import Foundation


struct Role {
    var id: UUID
    var name: String            // 역할 이름 (예: 조커, 타임키퍼 등)
    var explain: String     // 간단한 설명
    var guide: String           // 역할 수행 가이드
    var imageName: String       // 에셋 이미지 이름

    init(name: String, explain: String, guide: String, imageName: String) {
        self.id = UUID()
        self.name = name
        self.explain = explain
        self.guide = guide
        self.imageName = imageName
    }
}
