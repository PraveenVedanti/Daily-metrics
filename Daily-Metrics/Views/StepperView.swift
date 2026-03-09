//
//  StepperView.swift
//  Daily-Metrics
//
//  Created by Praveen Kumar Vedanti on 3/4/26.
//

import Foundation
import SwiftUI

struct StepperView: View {
    
    let onPlusTap: () -> Void
    let onMinusTap: () -> Void
    let buttonHeight: CGFloat
    let color: Color
    
    @Environment(\.colorScheme) var colorScheme
    
    init(
        buttonHeight: CGFloat,
        color: Color,
        onPlusTap: @escaping () -> Void,
        onMinusTap: @escaping () -> Void
    ) {
        self.buttonHeight = buttonHeight
        self.color = color
        self.onPlusTap = onPlusTap
        self.onMinusTap = onMinusTap
    }
    
    var body: some View {
        HStack(spacing: 16) {
            decrementButton
            
            incrementButton
        }
    }
    
    private var incrementButton: some View {
        Button {
           onPlusTap()
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color(uiColor: .secondarySystemGroupedBackground))
                .frame(width: buttonHeight * 1.2, height: buttonHeight * 1.2)
                .background(color.opacity(colorScheme == .dark ?  0.6 : 0.8))
                .clipShape(Circle())
        }
    }
    
    private var decrementButton: some View {
        Button {
            onMinusTap()
        } label: {
            Image(systemName: "minus")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color.red.opacity(0.8))
                .frame(width: buttonHeight * 0.8, height: buttonHeight * 0.8)
                .background(Color.clear)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.red.opacity(0.6), lineWidth: 0.4)
                )
        }
    }
}
