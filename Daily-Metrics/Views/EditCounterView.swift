//
//  EditCounterView.swift
//  Daily-Metrics
//
//  Created by Praveen Kumar Vedanti on 3/8/26.
//

import Foundation
import SwiftUI

// MARK: - Edit counter view.

struct EditCounterView: View {
    let metric: Metric

    // Metric color
    @State private var metricColor: Color = .blue
    
    // Metric name and descriptions.
    @State private var metricName: String = ""
    
    @State private var initialValue: String = ""
    @State private var incrementBy: String = ""
    @State private var metricTarget: String = ""
    
    @FocusState private var isTextFieldFocused: Bool
    
    // Environment variable to dismiss sheet.
    @Environment(\.dismiss) var dismiss
    
    // Metric colors.
    @State private var firstSetColors: [Color] = [.blue, .green, .yellow, .red, .orange, .brown]
    @State private var secondSetColors: [Color] = [.cyan, .teal, .purple, .indigo, .gray, .pink]
    
    init(metric: Metric) {
        self.metric = metric
        _metricName = State(initialValue: metric.name)
        _initialValue = State(initialValue: "\(metric.value)")
        _incrementBy = State(initialValue: "\(metric.increment)") 
        _metricColor = State(initialValue: color(from: metric.color ?? "blue"))
    }
    
    var body: some View {
        NavigationStack {
            List {
                
                // Counter name section
                Section {
                    metricNameTextField
                }
                
                // Counter value section
                Section("Counter value") {
                    initialValueTextField
                }

                // Increment by section
                Section(LocalizedStrings.incrementByTextFieldHeader) {
                    incrementByTextField
                }
                
                // Set the target
                Section("Target (Optional)") {
                    metricTargetTextField
                }
                
                // Color selection section.
                Section {
                    VStack(spacing: 24) {
                        ColorPickerView(colors: firstSetColors, selectedColor: $metricColor)
                        ColorPickerView(colors: secondSetColors, selectedColor: $metricColor)
                    }
                } header: {
                    Text(LocalizedStrings.colorSectionHeader)
                } footer: {
                    Text(LocalizedStrings.colorSectionFooter)
                }
            }
            .onAppear {
                Task {
                    try? await Task.sleep(nanoseconds: 500_000_000)
                    await MainActor.run {
                        isTextFieldFocused = true
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .buttonStyle(.plain)
                }
            }
            .navigationTitle("Edit counter")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var metricNameTextField: some View {
        TextField(metric.name, text: $metricName)
            .textFieldStyle(.automatic)
            .focused($isTextFieldFocused)
            .foregroundColor(.primary)
            .textInputAutocapitalization(.words)
    }
    
    private var initialValueTextField: some View {
        TextField("\(metric.value)", text: $initialValue)
            .keyboardType(.numberPad)
            .textFieldStyle(.automatic)
            .foregroundColor(.primary)
    }
    
    private var incrementByTextField: some View {
        TextField("\(metric.increment)", text: $incrementBy)
            .keyboardType(.numberPad)
            .textFieldStyle(.automatic)
            .foregroundColor(.primary)
    }
    
    private var metricTargetTextField: some View {
        TextField("1", text: $metricTarget)
            .keyboardType(.numberPad)
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
}
