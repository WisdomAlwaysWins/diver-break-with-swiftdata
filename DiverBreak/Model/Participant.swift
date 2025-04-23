//
//  Participant.swift
//  DiverBreak
//
//  Created by J on 4/16/25.
//

import Foundation
import SwiftData

/*
    MARK: 참가자 데이터 모델 (SwiftData)
*/

@Model
class Participant { 
    @Attribute(.unique) var id: UUID // 식별자
    var name: String // 닉네임
    var assignedRoleName: String? // 배정된 역할 이름
    
    var assignedRole: Role? { // 역할 전체 정보 -> 객체 전체를 저장하지 않고 역할 이름으로 연결함 (왜냐 직접 연결하니까 오류 파티에 갇힘 ^^) 그리고 굳이 역할 전체를 swiftData에 저장할 이유가 없음. 왜냐 역할은 CRUD 안할거니까
        guard let name = assignedRoleName else { return nil }
        return RoleCardProvider.role(named: name)
    }

    init(name: String, assignedRoleName: String? = nil) {
        self.id = UUID()
        self.name = name
        self.assignedRoleName = assignedRoleName
    }
    
}
