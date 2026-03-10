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
    
    @State private var initialValue: String = "0"
    @State private var incrementBy: String = "1"
    @State private var metricTarget: String = "0"
    
    @FocusState private var isTextFieldFocused: Bool
    
    // Environment variable to dismiss sheet.
    @Environment(\.dismiss) var dismiss
    
    // Metric colors.
    @State private var firstSetColors: [Color] = [.blue, .green, .yellow, .red, .orange, .brown]
    @State private var secondSetColors: [Color] = [.cyan, .teal, .purple, .indigo, .gray, .pink]
    
    var body: some View {
        NavigationStack {
            List {
                
                // Counter name section
                Section {
                    metricNameTextField
                }
                
                // Initial value section
                Section {
                    initialValueTextField
                } header: {
                    Text(LocalizedStrings.initialValueTextFiledHeader)
                } footer: {
                    Text(LocalizedStrings.initialValueTextFieldFooter)
                }

                // Increment by section
                Section {
                    incrementByTextField
                } header: {
                    Text(LocalizedStrings.incrementByTextFieldHeader)
                } footer: {
                    Text(LocalizedStrings.incrementByTextFieldFooter)
                }
                
                // Set the target
                Section {
                    metricTargetTextField
                } header: {
                    Text("Target (Optional)")
                } footer: {
                    Text("Set target for your counter to track progress")
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
                metricName = metric.name
                initialValue = "\(metric.value)"
                incrementBy = "\(metric.increment)"
                metricColor = color(from: metric.color ?? "blue")
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
        TextField("", text: $metricName)
            .focused($isTextFieldFocused)
    }
    
    private var initialValueTextField: some View {
        TextField("", text: $initialValue)
            .keyboardType(.numberPad)
    }
    
    private var incrementByTextField: some View {
        TextField("\(metric.increment)", text: $incrementBy)
            .keyboardType(.numberPad)
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
