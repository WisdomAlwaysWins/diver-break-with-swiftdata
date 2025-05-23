//
//  RoleProvider.swift
//  DiverBreak
//
//  Created by J on 4/17/25.
//

import Foundation

struct RoleCardProvider {
    static let roles: [Role] = [
        Role(
            name: "에너지 체커",
            explain: "다이버의 에너지를 확인하고 당보충 아이디어를 제공합니다.",
            guide: "에너지 레벨 물어보기\n“간식 타임?” 물어보기",
            imageName: "energychecker",
            fullScreenImageName: "energycard"
        ),
        Role(
            name: "개인시간 서포터",
            explain: "혼자만의 시간을 제안하고 개별 휴식 방법을 안내합니다.",
            guide: "케이브에서 각자의 시간\n개별 산책 제안하기",
            imageName: "metimesupporter",
            fullScreenImageName: "metimecard"
        ),
        Role(
            name: "분위기 조종사",
            explain: "뜨거운 분위기를 위해 지나치게 조용한 분위기를 걷어냅니다.",
            guide: "노래 틀기\n노트북 닫기\n물 마시러 가자 제안하기",
            imageName: "flowcontroller",
            fullScreenImageName: "flowcard"
        ),
        Role(
            name: "거북목 보안관",
            explain: "거북목 같은 디스크를 예방하고 다이버를 보호합니다.",
            guide: "손목/목 스트레칭하기\n눈 감고 눈알 운동하기",
            imageName: "discguardian",
            fullScreenImageName: "disccard"
        ),
        Role(
            name: "산소 마스터",
            explain: "집중력과 피로도를 개선하기 위해 산소 채우는 휴식을 안내합니다.",
            guide: "창문 열기\n심호흡하기\n에어컨 온도 조절하기",
            imageName: "oxygenmaster",
            fullScreenImageName: "oxygencard"
        ),
        Role(
            name: "공간이동 전문가",
            explain: "일상을 탈피하여 다양한 회의 장소를 제안합니다.",
            guide: "회의 중 카페테리아,\n6층으로 이동하기",
            imageName: "boatnavigator",
            fullScreenImageName: "spacecard"
        ),
        Role(
            name: "조커",
            explain: "조커는 모든 역할들의 휴식 자격을 수행할 수 있습니다.",
            guide: "뭐든 하세요.",
            imageName: "joker",
            fullScreenImageName: "jokercard"
        )
    ]
    
    static func role(named name: String) -> Role? {
        roles.first { $0.name == name }
    }
}
