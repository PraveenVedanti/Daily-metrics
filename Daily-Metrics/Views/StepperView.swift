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
    
    init(
        onPlusTap: @escaping () -> Void,
        onMinusTap: @escaping () -> Void
    ) {
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
                .foregroundStyle(Color.blue)
                .frame(width: 40, height: 40)
                .background(Color.blue.opacity(0.12))
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
                .frame(width: 40, height: 40)
                .background(Color.orange.opacity(0.12))
                .clipShape(Circle())
        }
    }
}
