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
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    isTextFieldFocused = true
                }
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
    
    private var metricNameTextField: some View {
        TextField("Counter name (Required)", text: $metricName)
            .focused($isTextFieldFocused)
    }
    
    private var metricDescriptionTextField: some View {
        TextField("Counter description", text: $metricDescription)
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
