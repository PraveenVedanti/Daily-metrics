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
            
            VStack(alignment: .leading, spacing: 4) {
                metricTitleView
                metricValueView
            }
            
            Spacer()
                .frame(height: 12)
            
            // Stepper Section
            HStack(spacing: 15) {
                // Decrement counter
                decrementButton
                
                // Increment counter
                incrementButton
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 4)
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
            Text(metricUnit)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    private var incrementButton: some View {
        Button {
            metricValue += 1
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color.teal)
                .frame(width: 38, height: 38)
                .background(Color.teal.opacity(0.1))
                .clipShape(Circle())
        }
    }
    
    private var decrementButton: some View {
        Button {
            metricValue -= 1
        } label: {
            Image(systemName: "minus")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color.orange)
                .frame(width: 38, height: 38)
                .background(Color.orange.opacity(0.1))
                .clipShape(Circle())
        }
    }
}
