//
//  AddMetricsView.swift
//  Daily-Metrics
//
//  Created by Praveen Kumar Vedanti on 3/3/26.
//

import Foundation
import SwiftUI
import SwiftData

extension Color {
    
}

// MARK: - Add metrics view.

struct AddMetricsView: View {
    
    // Metric name
    @State private var metricName: String = ""
    
    // Metric values.
    @State private var initialValue: String = "0"
    @State private var incrementBy: String = "1"
    
    // Metric color
    @State private var metricColor: Color = .counterBlue
    
    // Model context for local data.
    @Environment(\.modelContext) private var modelContext
    
    @FocusState private var isTextFieldFocused: Bool
    
    // Environment variable to dismiss sheet.
    @Environment(\.dismiss) var dismiss
    
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
                
            }.onTapGesture {
                isTextFieldFocused = false
            }
            .onAppear {
                Task {
                    try? await Task.sleep(nanoseconds: 100_000_000)
                    await MainActor.run {
                        isTextFieldFocused = true
                    }
                }
            }
            .navigationTitle(LocalizedStrings.newCounterTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .buttonStyle(.plain)
                }
               
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        addNewMetrixToContext()
                    } label: {
                        Image(systemName: "checkmark")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(metricName.isEmpty ? .gray.opacity(0.8) : .blue)
                    .disabled(metricName.isEmpty)
                }
            }
        }
    }
    
    private var metricNameTextField: some View {
        TextField(LocalizedStrings.metricNameTextFieldPlaceholder, text: $metricName)
            .focused($isTextFieldFocused)
    }
    
    private var initialValueTextField: some View {
        TextField("0", text: $initialValue)
            .keyboardType(.numberPad)
    }
    
    private var incrementByTextField: some View {
        TextField("1", text: $incrementBy)
            .keyboardType(.numberPad)
    }
    
    private func addNewMetrixToContext() {
        guard let initialValueInt = Int(initialValue) else {
            dismiss()
            return
        }
        guard let incrementByInt = Int(incrementBy) else {
            dismiss()
            return
        }
        
        // Add new metric to local database.
        let newMetric = Metric(
            name: metricName,
            value: initialValueInt,
            increment: incrementByInt,
            color: ColorToken.colorsToString(metricColor)
        )
        modelContext.insert(newMetric)
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Failed to save context: \(error)")
            dismiss()
        }
    }
}

// MARK: - Colour picker view.

struct ColorPickerView: View {
    
    // List of colors available to choose from
    let colors: [Color]
    
    // Binding variable for selected color.
    @Binding var selectedColor: Color

    var body: some View {
        HStack(spacing: 24) {
            ForEach(colors, id: \.self) { color in
                Button(action: {
                    selectedColor = color
                }) {
                    Circle()
                        .fill(color.opacity(0.8))
                        .frame(width: 36, height: 36)
                        .overlay(
                            Circle()
                                .stroke(color.opacity(0.4), lineWidth: 2)
                                .padding(-6)
                                .opacity(selectedColor == color ? 1 : 0)
                        )
                }
                .buttonStyle(.plain)
                .animation(.spring(), value: selectedColor)
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Localized strings.

struct LocalizedStrings {
    static let initialValueTextFiledHeader = NSLocalizedString("Initial value", comment: "Initial value text field header")
    static let initialValueTextFieldFooter = NSLocalizedString("Enter initial value (default is 0)", comment: "Initial value text field footer")
    
    static let incrementByTextFieldHeader = NSLocalizedString("Increment by", comment: "Increment by text field header")
    static let incrementByTextFieldFooter = NSLocalizedString("Enter the amount the counter should increase per tap (default is 1)", comment: "Increment by text field footer")
    
    static let colorSectionHeader = NSLocalizedString("Color", comment: "Color section header")
    static let colorSectionFooter = NSLocalizedString("Choose a color for your counter", comment: "Color section footer")
    
    static let metricNameTextFieldPlaceholder = NSLocalizedString("Counter name (Required)", comment: "Counter name text field placeholder")
    
    static let newCounterTitle = NSLocalizedString("New Counter", comment: "New counter navigation title")
    
    static let counterValueTextFiledHeader = NSLocalizedString("Counter value", comment: "Counter value text field header")
}
