//
//  MetricsViewModel.swift
//  Daily-Metrics
//
//  Created by Praveen Kumar Vedanti on 3/5/26.
//

import Foundation
import SwiftUI
internal import Combine

class MetricsViewModel: ObservableObject {

    @AppStorage("selectedColorName") var selectedColorName: String = "Blue"
    
    // Helper to get the actual Color object from the stored String
    var selectedColor: Color {
        Color.fromName(selectedColorName)
    }
    
    // Update the selection
    func updateColor(_ color: Color) {
        objectWillChange.send()
        selectedColorName = color.displayName
    }
}


extension Color {
    // Convert String back to Color
    static func fromName(_ name: String) -> Color {
        switch name {
        case "Red": return .red
        case "Green": return .green
        case "Yellow": return .yellow
        case "Blue": return .blue
        case "Orange": return .orange
        case "Brown": return .brown
        default: return .blue
        }
    }
    
    // Get the name for storage
    var displayName: String {
        switch self {
        case .red: return "Red"
        case .green: return "Green"
        case .yellow: return "Yellow"
        case .blue: return "Blue"
        case .orange: return "Orange"
        case .brown: return "Brown"
        default: return "Blue"
        }
    }
}
