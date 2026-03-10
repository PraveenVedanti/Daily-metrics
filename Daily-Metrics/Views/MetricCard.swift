//
//  MetricCard.swift
//  Daily-Metrics
//
//  Created by Praveen Kumar Vedanti on 3/2/26.
//

import Foundation
import SwiftUI
import SwiftData

// MARK: - Metric card.

public struct MetricCard: View {
    
    // Metric object.
    let metric: Metric
    
    // Model context to fetch data.
    @Environment(\.modelContext) private var modelContext
    
    @State private var showEditMetricsSheet = false
    
    @Environment(\.colorScheme) var colorScheme
    
    init(
        metric: Metric,
    ) {
        self.metric = metric
    }
    
    public var body: some View {
        
        HStack {
            decrementButton
                .frame(maxWidth: .infinity, alignment: .leading)

            
            VStack(spacing: 8) {
                metricTitleView
                metricValueView
            }
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
            
            incrementButton
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(
                    colorScheme == .light
                    ? metricColor.opacity(0.04)
                    : metricColor.opacity(0.2)
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(
                    colorScheme == .light
                    ? metricColor.opacity(0.4)
                    : metricColor.opacity(0.6),
                    lineWidth: 0.6
                )
        )
        .shadow(
            color: colorScheme == .light
            ? .black.opacity(0.06)
            : .black.opacity(0.35),
            radius: colorScheme == .light ? 10 : 4,
            y: colorScheme == .light ? 4 : 2
        )
    }
    
    private var metricColor: Color {
        color(from: metric.color ?? "blue")
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
        case "gray":
            return .gray
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
        Text("\(metric.value)")
            .font(.system(size: 34, weight: .bold, design: .rounded))
            .contentTransition(.numericText())
            .monospacedDigit()
    }
    
    private var incrementButton: some View {
        Button {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
            metric.increment(in: modelContext)
            updateMetric()
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color(uiColor: .secondarySystemGroupedBackground))
                .frame(width: 48, height: 48)
                .background(metricColor.opacity(colorScheme == .dark ?  0.6 : 0.8))
                .clipShape(Circle())
        }
    }
    
    private var decrementButton: some View {
        Button {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            
            metric.decrement(in: modelContext)
            updateMetric()
        } label: {
            Image(systemName: "minus")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(metricColor.opacity(0.8))
                .frame(width: 48, height: 48)
                .background(Color.clear)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(metricColor.opacity(0.6), lineWidth: 0.4)
                )
        }
    }

}
