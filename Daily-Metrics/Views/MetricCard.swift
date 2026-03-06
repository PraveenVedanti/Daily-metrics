//
//  MetricCard.swift
//  Daily-Metrics
//
//  Created by Praveen Kumar Vedanti on 3/2/26.
//

import Foundation
import SwiftUI

public struct MetricCard: View {
    
    @State private var metricTitle: String
    @State private var metricValue: Int
    @State private var metricUnit: String
    
    public init(
        metricTitle: String,
        metricValue: Int,
        metricUnit: String
    ) {
        self.metricTitle = metricTitle
        self.metricValue = metricValue
        self.metricUnit = metricUnit
    }
    
    public var body: some View {
        HStack(alignment: .center) {
            
            VStack(alignment: .leading, spacing: 8) {
                metricTitleView
                metricValueView
            }
            
            Spacer()
                .frame(height: 12)
            
            // Stepper Section
            StepperView {
                metricValue += 1
            } onMinusTap: {
                metricValue -= 1
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
    
    private var metricTitleView: some View {
        Text(metricTitle.uppercased())
            .font(.caption2.bold())
            .foregroundStyle(.secondary)
    }
    
    private var metricValueView: some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            Text("\(metricValue)")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .contentTransition(.numericText())
            Text(metricUnit)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}
