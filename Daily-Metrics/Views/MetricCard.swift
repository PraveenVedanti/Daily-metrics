//
//  MetricCard.swift
//  Daily-Metrics
//
//  Created by Praveen Kumar Vedanti on 3/2/26.
//

import Foundation
import SwiftUI
import SwiftData

public struct MetricCard: View {
    
    let metric: Metric
    
    @StateObject private var viewModel = MetricsViewModel()
    
    @Environment(\.modelContext) private var modelContext
    
    init(
        metric: Metric,
    ) {
        self.metric = metric
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
            StepperView(
                buttonHeight: 40,
                color: color(from: metric.color ?? "blue")
            ) {
                metric.increment(in: modelContext)
                updateMetric()
            } onMinusTap: {
                metric.decrement(in: modelContext)
                updateMetric()
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
    
    private func updateMetric() {
        do {
            try modelContext.save()
        } catch {
            print("Failed to update: \(error)")
        }
    }
    
    func color(from string: String) -> Color {
        switch string.lowercased() {
        case "red":
            return .red
        case "green":
            return .green
        case "yellow":
            return .yellow
        case "blue":
            return .blue
        case "orange":
            return .orange
        case "brown":
            return .brown
        case "purple":
            return .purple
        case "cyan":
            return .cyan
        case "teal":
            return .teal
        case "indigo":
            return .indigo
        case "mint":
            return .mint
        case "pink":
            return .pink
        default:
            return .blue
        }
    }
    
    
    private var metricTitleView: some View {
        Text(metric.name.uppercased())
            .font(.caption2.bold())
            .foregroundStyle(color(from: metric.color ?? "blue"))
    }
    
    private var metricValueView: some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            Text("\(metric.value)")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .contentTransition(.numericText())
            Text(metric.unit ?? "")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}
