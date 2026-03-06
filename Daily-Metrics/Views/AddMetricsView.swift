//
//  AddMetricsView.swift
//  Daily-Metrics
//
//  Created by Praveen Kumar Vedanti on 3/3/26.
//

import Foundation
import SwiftUI

struct AddMetricsView: View {
    
    @State private var metricName: String = ""
    @State private var metricDescription: String = ""
    
    @State private var initialValue: Int = 0
    @State private var incrementBy: Int = 1
    
    @AppStorage("selectedThemeColorName") var selectedThemeColorName: String = "Red"
    
    @FocusState private var isTextFieldFocused: Bool
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    metricNameTextField
                    metricDescriptionTextField
                }
                
                Section {
                    CounterStepperRow(
                        value: $initialValue, title: "Initial value"
                    )
                }

                Section {
                    CounterStepperRow(
                        value: $incrementBy, title: "Increment by"
                    )
                }
                
                Section {
                    colorSelectionView
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
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                    }
                    .buttonStyle(.plain)
                    .disabled(metricName.isEmpty)
                }
            }
        }
    }
    
    private var colorSelectionView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Color")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            ColorPickerView()
        }
    }
    
    private var metricNameTextField: some View {
        TextField("Counter name (Required)", text: $metricName)
            .focused($isTextFieldFocused)
    }
    
    private var metricDescriptionTextField: some View {
        TextField("what are you tracking?(Optional)", text: $metricDescription)
    }
}


struct CounterStepperRow: View {
    
    @Binding var value: Int
    
    let title: String
    var step: Int = 1
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                
            HStack(spacing: 24) {
                Button {
                    if value >= step {
                        value -= step
                    }
                } label: {
                    Image(systemName: "minus")
                        .font(.system(size: 16, weight: .regular))
                        .frame(width: 32, height: 32)
                        .background(Color.orange.opacity(0.15))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
                
                Spacer()
                
                Text("\(value)")
                    .font(.system(size: 34, weight: .regular, design: .rounded))
                
                Spacer()
                
                Button {
                    value += step
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .regular))
                        .frame(width: 32, height: 32)
                        .background(Color.blue.opacity(0.15))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
        }
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
        .padding()
    }
}
