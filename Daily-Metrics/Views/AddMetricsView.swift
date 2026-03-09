//
//  AddMetricsView.swift
//  Daily-Metrics
//
//  Created by Praveen Kumar Vedanti on 3/3/26.
//

import Foundation
import SwiftUI
import SwiftData

struct AddMetricsView: View {
    
    // Metric name and descriptions.
    @State private var metricName: String = ""
    @State private var metricDescription: String = ""
    @State private var metricUnit: String = ""
    
    // Metric values.
    @State private var initialValue: String = "0"
    @State private var incrementBy: String = "1"
    @State private var metricTarget: String = "0"
    
    // Metric color
    @State private var metricColor: Color = .blue
    
    // Model context for local data.
    @Environment(\.modelContext) private var modelContext
    
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
                    metricDescriptionTextField
                    metricUnitTextField
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
                
            }.onTapGesture {
                isTextFieldFocused = false
            }
            .onAppear {
                isTextFieldFocused = true
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
                            desc: metricDescription,
                            unit: metricUnit,
                            value: initialValueInt,
                            increment: incrementByInt,
                            color: colorsToString(metricColor)
                        )
                        modelContext.insert(newMetric)
                        
                        do {
                            try modelContext.save()
                            dismiss()
                        } catch {
                            print("Failed to save context: \(error)")
                            dismiss()
                        }
                    } label: {
                        Text("Add")
                    }
                    .buttonStyle(.plain)
                    .disabled(metricName.isEmpty)
                }
            }
        }
    }
    
    private var metricNameTextField: some View {
        TextField(LocalizedStrings.metricNameTextFieldPlaceholder, text: $metricName)
            .focused($isTextFieldFocused)
    }
    
    private var metricDescriptionTextField: some View {
        TextField(LocalizedStrings.metricDescriptionTextFieldPlaceholder, text: $metricDescription)
    }
    
    private var metricUnitTextField: some View {
        TextField(LocalizedStrings.unitTextFieldPlaceholder, text: $metricUnit)
    }
    
    private var initialValueTextField: some View {
        TextField("0", text: $initialValue)
            .keyboardType(.numberPad)
    }
    
    private var incrementByTextField: some View {
        TextField("1", text: $incrementBy)
            .keyboardType(.numberPad)
    }
    
    private var metricTargetTextField: some View {
        TextField("1", text: $metricTarget)
            .keyboardType(.numberPad)
    }
    
    private func colorsToString(_ color: Color) -> String {
        switch color {
        case .red:
            return "red"
        case .green:
            return "green"
        case .yellow:
            return "yellow"
        case .blue:
            return "blue"
        case .orange:
            return "orange"
        case .brown:
            return "brown"
        case .purple:
            return "purple"
        case .cyan:
            return "cyan"
        case .teal:
            return "teal"
        case .indigo:
            return "indigo"
        case .gray:
            return "gray"
        case .pink:
            return "pink"
            
        default:
            return "blue"
        }
    }
}


struct ColorPickerView: View {
    
    // List of colors available to choose from
    let colors: [Color]
    
    // Binding variable for selected color.
    @Binding var selectedColor: Color

    var body: some View {
        HStack(spacing: 16) {
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

struct LocalizedStrings {
    static let initialValueTextFiledHeader = NSLocalizedString("Initial value", comment: "Initial value text field header")
    static let initialValueTextFieldFooter = NSLocalizedString("Enter initial value (default is 0)", comment: "Initial value text field footer")
    
    static let incrementByTextFieldHeader = NSLocalizedString("Increment by", comment: "Increment by text field header")
    static let incrementByTextFieldFooter = NSLocalizedString("Enter the amount the counter should increase per tap (default is 1)", comment: "Increment by text field footer")
    
    static let colorSectionHeader = NSLocalizedString("Color", comment: "Color section header")
    static let colorSectionFooter = NSLocalizedString("Choose a color for your counter", comment: "Color section footer")
    
    static let metricNameTextFieldPlaceholder = NSLocalizedString("Counter name (Required)", comment: "Counter name text field placeholder")
    static let metricDescriptionTextFieldPlaceholder = NSLocalizedString("what are you tracking?(Optional)", comment: "Counter description text field")
    static let unitTextFieldPlaceholder = NSLocalizedString("Unit (Optional)", comment: "Unit text field placeholder")
    
    static let newCounterTitle = NSLocalizedString("New Counter", comment: "New counter navigation title")
}
