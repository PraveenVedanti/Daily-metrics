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
    
    // Metric description.
    @State private var metricDesc: String = ""
    
    // Metric values
    @State private var initialValue: String = ""
    @State private var incrementBy: String = ""
    @State private var metricGoal: String = ""
    
    @FocusState private var isTextFieldFocused: Bool
    
    @State private var isGoalTurnedOn: Bool = false
    
    // Environment variable to dismiss sheet.
    @Environment(\.dismiss) var dismiss
    
    // Model context for local data.
    @Environment(\.modelContext) private var modelContext
    
    init(metric: Metric) {
        self.metric = metric
        _metricName = State(initialValue: metric.name)
        _metricDesc = State(initialValue: metric.desc ?? "")
        _initialValue = State(initialValue: "\(metric.value)")
        _incrementBy = State(initialValue: "\(metric.increment)") 
        _metricColor = State(initialValue: ColorToken.stringToColor(metric.color ?? "counterBlue"))
        _isGoalTurnedOn = State(initialValue: metric.hasTarget ?? false)
        _metricGoal = State(initialValue: "\(metric.target ?? 0)")
    }
    
    var body: some View {
        NavigationStack {
            Form {
                
                // Counter name section
                Section {
                    metricNameTextField
                    metricDesTextField
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
                
                // Goals section.
                Section {
                    VStack(spacing: 16) {
                        if isGoalTurnedOn {
                            Toggle(isOn: $isGoalTurnedOn) {
                                Text(DMStrings.goalText)
                            }
                            
                            Divider()
                            goalsTextField
                        } else {
                            Toggle(isOn: $isGoalTurnedOn) {
                                Text(DMStrings.goalText)
                            }
                            
                            if isGoalTurnedOn {
                                Divider()
                                goalsTextField
                            }
                        }
                    }
                } header: {
                    Text("")
                } footer: {
                    Text(DMStrings.goalSectionFooter)
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
    
    private var metricDesTextField: some View {
        TextField("\(metric.desc ?? DMStrings.metricDescTextFieldPlaceholder)", text: $metricDesc)
            .textFieldStyle(.automatic)
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
    
    private var goalsTextField: some View {
        TextField("Set goal for counter", text: $metricGoal)
            .keyboardType(.numberPad)
    }
    
    private func updateMetric(_ metric: Metric) {
        metric.name = metricName
        metric.desc = metricDesc
        metric.value = Int(initialValue) ?? metric.value
        metric.increment = Int(incrementBy) ?? metric.increment
        metric.color = ColorToken.colorsToString(metricColor)
        metric.target = Int(metricGoal) ?? metric.target
        metric.hasTarget = isGoalTurnedOn
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Failed to update metric: \(error)")
            dismiss()
        }
    }
}
