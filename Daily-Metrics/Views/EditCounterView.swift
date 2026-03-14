//
//  EditCounterView.swift
//  Daily-Metrics
//
//  Created by Praveen Kumar Vedanti on 3/8/26.
//

import Foundation
import SwiftUI
import SwiftData

// MARK: - Edit counter view.

struct EditCounterView: View {
    let metric: Metric

    // Metric color
    @State private var metricColor: Color = .blue
    
    // Metric name and descriptions.
    @State private var metricName: String = ""
    
    // Metric values
    @State private var initialValue: String = ""
    @State private var incrementBy: String = ""
    
    @FocusState private var isTextFieldFocused: Bool
    
    // Environment variable to dismiss sheet.
    @Environment(\.dismiss) var dismiss
    
    // Model context for local data.
    @Environment(\.modelContext) private var modelContext
    
    init(metric: Metric) {
        self.metric = metric
        _metricName = State(initialValue: metric.name)
        _initialValue = State(initialValue: "\(metric.value)")
        _incrementBy = State(initialValue: "\(metric.increment)") 
        _metricColor = State(initialValue: ColorToken.stringToColor(metric.color ?? "counterBlue"))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                
                // Counter name section
                Section {
                    metricNameTextField
                }
                
                // Counter value section
                Section(DMStrings.counterCurrentValueHeader) {
                    initialValueTextField
                }

                // Increment by section
                Section(DMStrings.incrementByTextFieldHeader) {
                    incrementByTextField
                }
                
                // Color selection section.
                Section {
                    VStack(spacing: 24) {
                        ColorPickerView(colors: ColorToken.firstSetCounterColors, selectedColor: $metricColor)
                        ColorPickerView(colors: ColorToken.secondSetCounterColors, selectedColor: $metricColor)
                    }
                } header: {
                    Text(DMStrings.colorSectionHeader)
                } footer: {
                    Text(DMStrings.colorSectionFooter)
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: DMIcons.crossMark)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Dismiss")
                    .accessibilityHint("Discards changes and closes the sheet")
                    .accessibilityAddTraits(.isButton)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        updateMetric(self.metric)
                    } label: {
                        Image(systemName: DMIcons.checkMark)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Save")
                    .accessibilityHint("Saves changes to \(metric.name)")
                    .accessibilityAddTraits(.isButton)
                }
            }
            .navigationTitle(DMStrings.editCounterSheetTitle)
            .navigationBarTitleDisplayMode(.inline)
        }
        .onTapGesture {
            isTextFieldFocused = false
        }
        .task {
            try? await Task.sleep(nanoseconds: 150_000_000)
            isTextFieldFocused = true
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
    
    private func updateMetric(_ metric: Metric) {
        metric.name = metricName
        metric.value = Int(initialValue) ?? metric.value
        metric.increment = Int(incrementBy) ?? metric.increment
        metric.color = ColorToken.colorsToString(metricColor)
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Failed to update metric: \(error)")
            dismiss()
        }
    }
}
