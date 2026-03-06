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
    
    init(
        buttonHeight: CGFloat,
        onPlusTap: @escaping () -> Void,
        onMinusTap: @escaping () -> Void
    ) {
        self.buttonHeight = buttonHeight
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
                .foregroundStyle(Color.teal)
                .frame(width: buttonHeight, height: buttonHeight)
                .background(Color.teal.opacity(0.12))
                .clipShape(Circle())
        }
    }
    
    private var decrementButton: some View {
        Button {
            onMinusTap()
        } label: {
            Image(systemName: "minus")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color.orange)
                .frame(width: buttonHeight, height: buttonHeight)
                .background(Color.orange.opacity(0.12))
                .clipShape(Circle())
        }
    }
}
