//
//  Font+Extension.swift
//  DiverBreak
//
//  Created by J on 4/17/25.
//

import SwiftUI

extension Font {
    static func round(_ size: CGFloat, weight: Weight = .regular) -> Font {
        return .custom("SFProRounded-\(weight.fontName)", size: size)
    }
}

extension Font.Weight {
    var fontName: String {
        switch self {
        case .ultraLight: return "Ultralight"
        case .thin: return "Thin"
        case .light: return "Light"
        case .regular: return "Regular"
        case .medium: return "Medium"
        case .semibold: return "Semibold"
        case .bold: return "Bold"
        case .heavy: return "Heavy"
        case .black: return "Black"
        default: return "Regular"
        }
    }
}

