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
    
    @State private var metricName: String = ""
    @State private var metricDescription: String = ""
    @State private var metricUnit: String = ""
    
    @State private var initialValue: String = "0"
    @State private var incrementBy: String = "1"
    @State private var metricColor: Color = .blue
    
    @Environment(\.modelContext) private var modelContext
    
    @FocusState private var isTextFieldFocused: Bool
    
    @StateObject private var viewModel = MetricsViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    @State private var firstSetColors: [Color] = [.blue, .green, .yellow, .red, .orange, .brown]
    @State private var secondSetColors: [Color] = [.cyan, .teal, .purple, .indigo, .mint, .pink]
    
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
                
                // Color selection section.
                Section {
                    VStack(spacing: 24) {
                        ColorPickerView(colors: firstSetColors, selectedColor: $metricColor)
                        ColorPickerView(colors: secondSetColors, selectedColor: $metricColor)
                    }
                } header: {
                    Text("Color")
                } footer: {
                    Text("Choose a color for your counter")
                }
                
            }.onTapGesture {
                isTextFieldFocused = false
            }
            .onAppear {
                isTextFieldFocused = true
            }
            .navigationTitle("New Counter")
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
                            print("Initial value return")
                            dismiss()
                            return
                        }
                        guard let incrementByInt = Int(incrementBy) else {
                            print("incrementBy value return")
                            dismiss()
                            return
                        }
                        
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
                        Image(systemName: "checkmark")
                    }
                    .buttonStyle(.plain)
                    .disabled(metricName.isEmpty)
                }
            }
        }
    }
    
    private var metricNameTextField: some View {
        TextField("Counter name (Required)", text: $metricName)
            .focused($isTextFieldFocused)
    }
    
    private var metricDescriptionTextField: some View {
        TextField("what are you tracking?(Optional)", text: $metricDescription)
    }
    
    private var metricUnitTextField: some View {
        TextField("Unit (Optional)", text: $metricUnit)
    }
    
    private var initialValueTextField: some View {
        TextField("0", text: $initialValue)
            .keyboardType(.numberPad)
    }
    
    private var incrementByTextField: some View {
        TextField("1", text: $incrementBy)
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
        case .mint:
            return "mint"
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
}
