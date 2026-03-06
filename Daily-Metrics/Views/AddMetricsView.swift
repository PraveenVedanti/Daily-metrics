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
    
    @State private var initialValue: String = ""
    @State private var incrementBy: String = ""
    
    @Environment(\.modelContext) private var modelContext
    
    @FocusState private var isTextFieldFocused: Bool
    
    @StateObject private var viewModel = MetricsViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    metricNameTextField
                    metricDescriptionTextField
                    metricUnitTextField
                }
                
                Section("Initial value") {
                   initialValueTextField
                }

                Section("Increment by") {
                    incrementByTextField
                }
                
                Section("Color") {
                    ColorPickerView()
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
                        
                        let newMetric = Metric(name: metricName, desc: metricDescription, unit: metricUnit, value: initialValueInt, increment: incrementByInt, color: "BLUE")
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
        TextField("Enter initial value for this counter", text: $initialValue)
            .keyboardType(.numberPad)
    }
    
    private var incrementByTextField: some View {
        TextField("Enter teh value to increment this counter for every tap", text: $incrementBy)
            .keyboardType(.numberPad)
    }
}


struct ColorPickerView: View {
    
    let colors: [Color] = [.red, .green, .yellow, .blue, .orange, .brown]
    @State private var selectedColor: Color? = nil
    @StateObject private var viewModel = MetricsViewModel()

    var body: some View {
        HStack(spacing: 16) {
            ForEach(colors, id: \.self) { color in
                Button(action: {
                    viewModel.updateColor(color)
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
