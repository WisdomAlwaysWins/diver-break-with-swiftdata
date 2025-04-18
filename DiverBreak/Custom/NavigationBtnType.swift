//
//  NavigationBtnType.swift
//  DiverBreak
//
//  Created by J on 4/17/25.
//

import Foundation

enum NavigationBtnType : String {
    case back = "뒤로 가기"
    case home = "홈으로"
    case help = "도움말"
    case play = "시작하기"
    
    var name : String {
        self.rawValue
    }
}
