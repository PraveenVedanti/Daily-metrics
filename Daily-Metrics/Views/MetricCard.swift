//
//  MetricCard.swift
//  Daily-Metrics
//
//  Created by Praveen Kumar Vedanti on 3/2/26.
//

import AVFoundation
import Foundation
import SwiftUI
import SwiftData

// MARK: - Metric card.

public struct MetricCard: View {
    
    // Metric object.
    let metric: Metric
    
    // Model context to fetch data.
    @Environment(\.modelContext) private var modelContext
    
    // Color scheme environment variable.
    @Environment(\.colorScheme) var colorScheme
    
    private let impactGenerator = UIImpactFeedbackGenerator(style: .medium)
    
    @Environment(\.editMode) private var editMode
        
    private var isEditing: Bool {
        editMode?.wrappedValue.isEditing ?? false
    }
    
    init(
        metric: Metric,
    ) {
        self.metric = metric
    }
    
    var isCompleted: Bool {
        metricProgress >= 1.0
    }
    
    public var body: some View {
        
        VStack(spacing: 8) {
            
            metricTitleView
            
            HStack {
                decrementButton
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                metricValueView
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                
                incrementButton
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
           
            if shouldShowGoals() {
                metricGoalView
            } else if isCompleted {
                HStack(spacing: 16) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(metricColor)
                        .scaleEffect(isCompleted ? 1.0 : 0.3)
                        .opacity(isCompleted ? 1.0 : 0)
                        .animation(.spring(response: 0.4, dampingFraction: 0.5), value: isCompleted)
                    
                    Text("Goal achieved!")
                        .font(.system(size: 16, weight: .light, design: .rounded))
                    
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isCompleted)
            }
            else if metric.target == nil {
                EmptyView()
            }
        }
        .onAppear {
            impactGenerator.prepare()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(
                    colorScheme == .light
                    ? metricColor.opacity(0.08)
                    : metricColor.opacity(0.18)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(
                            colorScheme == .light
                            ? metricColor.opacity(0.25)
                            : metricColor.opacity(0.25),
                            lineWidth: 1
                        )
                )
        )
    }
    
    private func shouldShowGoals() -> Bool {
        guard let hasTarget = metric.hasTarget else {
            return false
        }
        
        if !hasTarget { return false }
        
        if isCompleted { return false }
        
        return true
    }
    
    private var metricGoalView: some View {
        VStack(spacing: 8) {
            metricProgressValue
            CustomProgressBar(progress: metricProgress, color: metricColor)
                .animation(.spring(dampingFraction: 0.5), value: isCompleted)
        }
    }
    
    private var metricProgressValue: some View {
        HStack {
            Text("\(metric.value) / \(metric.target ?? 0)")
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .scaleEffect(isCompleted ? 1.3 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.4), value: isCompleted)
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 2)
    }
    
    private var metricColor: Color {
        ColorToken.stringToColor(metric.color ?? "counterBlue")
    }
    
    private func updateMetric() {
        do {
            try modelContext.save()
        } catch {
            print("Failed to update: \(error)")
        }
    }
    
    private var metricTitleView: some View {
        Text(metric.name)
            .font(.caption.bold())
            .kerning(1.5)
            .foregroundStyle(metricColor)
            .frame(maxWidth: .infinity, alignment: .center)
            .lineLimit(1)
    }
    
    private var metricValueView: some View {
        Text("\(metric.value)")
            .font(.system(size: 34, weight: .bold, design: .rounded))
            .contentTransition(.numericText())
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: metric.value)
    }
    
    private var incrementButton: some View {
        Button {
           
            // If haptics is enabled, apply it to button tap.
            let enabled = UserDefaults.standard.bool(forKey: "hapticsEnabled")
            if enabled {
                impactGenerator.impactOccurred()
            }
            
            let soundEnabled = UserDefaults.standard.bool(forKey: "soundEnabled")
            if soundEnabled {
                AudioServicesPlaySystemSound(1123)
            }
            
            metric.increment(in: modelContext)
        } label: {
            Image(systemName: DMIcons.plus)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color(uiColor: .secondarySystemGroupedBackground))
                .frame(width: 48, height: 48)
                .background(metricColor.opacity(colorScheme == .dark ?  0.6 : 0.8))
                .clipShape(Circle())
        }
        .disabled(isEditing)
        .buttonStyle(.borderless)
    }
    
    private var decrementButton: some View {
        Button {
            // If haptics is enabled, apply it to button tap.
            let enabled = UserDefaults.standard.bool(forKey: "hapticsEnabled")
            if enabled {
                impactGenerator.impactOccurred()
            }
            
            let soundEnabled = UserDefaults.standard.bool(forKey: "soundEnabled")
            if soundEnabled {
                AudioServicesPlaySystemSound(1123)
            }
           
            metric.decrement(in: modelContext)
        } label: {
            Image(systemName: DMIcons.minus)
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
        .disabled(isEditing)
        .buttonStyle(.borderless)
    }
    
    var metricProgress: Double {
        guard let target = metric.target, target != 0 else { return 0 }
        return min(max(Double(metric.value) / Double(target), 0), 1)
    }
}
