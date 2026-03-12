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
    
    @FocusState private var isTextFieldFocused: Bool
    
    // Environment variable to dismiss sheet.
    @Environment(\.dismiss) var dismiss
    
    init(metric: Metric) {
        self.metric = metric
        _metricName = State(initialValue: metric.name)
        _initialValue = State(initialValue: "\(metric.value)")
        _incrementBy = State(initialValue: "\(metric.increment)") 
        _metricColor = State(initialValue: ColorToken.stringToColor(metric.color ?? "counterBlue"))
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
                
                // Color selection section.
                Section {
                    VStack(spacing: 24) {
                        ColorPickerView(colors: ColorToken.firstSetCounterColors, selectedColor: $metricColor)
                        ColorPickerView(colors: ColorToken.secondSetCounterColors, selectedColor: $metricColor)
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
}
