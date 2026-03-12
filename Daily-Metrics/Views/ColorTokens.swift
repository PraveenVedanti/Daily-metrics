//
//  ColorTokens.swift
//  Daily-Metrics
//
//  Created by Praveen Kumar Vedanti on 3/11/26.
//

import Foundation
import SwiftUI

extension Color {

    static let counterRed        = Color(red: 0.93, green: 0.26, blue: 0.21)
    static let counterOrange     = Color(red: 0.97, green: 0.58, blue: 0.11)
    static let counterYellow     = Color(red: 0.97, green: 0.80, blue: 0.10)
    static let counterGreen      = Color(red: 0.15, green: 0.78, blue: 0.24)
    static let counterLightBlue  = Color(red: 0.43, green: 0.72, blue: 0.95)
    static let counterBlue       = Color(red: 0.07, green: 0.44, blue: 0.98)

    static let counterIndigo     = Color(red: 0.35, green: 0.27, blue: 0.87)
    static let counterHotPink    = Color(red: 0.93, green: 0.18, blue: 0.49)
    static let counterPurple     = Color(red: 0.72, green: 0.37, blue: 0.86)
    static let counterBrown      = Color(red: 0.62, green: 0.49, blue: 0.33)
    static let counterDarkSlate  = Color(red: 0.35, green: 0.43, blue: 0.49)
    static let counterDustyRose  = Color(red: 0.85, green: 0.63, blue: 0.58)
}

struct ColorToken {
    static let firstSetCounterColors: [Color] = [
        .counterBlue, .counterOrange, .counterYellow,
        .counterGreen, .counterLightBlue, .counterRed
    ]

    static let secondSetCounterColors: [Color] = [
        .counterIndigo, .counterHotPink, .counterPurple,
        .counterBrown, .counterDarkSlate, .counterDustyRose
    ]
    
    static func colorsToString(_ color: Color) -> String {
        switch color {
        case .counterRed:       return "counterRed"
        case .counterOrange:    return "counterOrange"
        case .counterYellow:    return "counterYellow"
        case .counterGreen:     return "counterGreen"
        case .counterLightBlue: return "counterLightBlue"
        case .counterBlue:      return "counterBlue"
        case .counterIndigo:    return "counterIndigo"
        case .counterHotPink:   return "counterHotPink"
        case .counterPurple:    return "counterPurple"
        case .counterBrown:     return "counterBrown"
        case .counterDarkSlate: return "counterDarkSlate"
        case .counterDustyRose: return "counterDustyRose"
        default:                return "counterBlue"
        }
    }
    
    static func stringToColor(_ string: String) -> Color {
        switch string {
        case "counterRed":       return .counterRed
        case "counterOrange":    return .counterOrange
        case "counterYellow":    return .counterYellow
        case "counterGreen":     return .counterGreen
        case "counterLightBlue": return .counterLightBlue
        case "counterBlue":      return .counterBlue
        case "counterIndigo":    return .counterIndigo
        case "counterHotPink":   return .counterHotPink
        case "counterPurple":    return .counterPurple
        case "counterBrown":     return .counterBrown
        case "counterDarkSlate": return .counterDarkSlate
        case "counterDustyRose": return .counterDustyRose
        default:                 return .counterBlue
        }
    }
}
