//
//  MetricsListView.swift
//  Daily-Metrics
//
//  Created by Praveen Kumar Vedanti on 3/2/26.
//

import Foundation
import SwiftData
import SwiftUI

struct MetricsListView: View {
    
    // Show add metrics sheet
    @State private var showAddMetricsSheet = false
    
    // Show global history sheet.
    @State private var showGlobalHistorySheet = false
    
    // Query 
    @Query(sort: \Metric.name, order: .reverse)
    
    // List of metrics created.
    private var metrics: [Metric]
    
    var body: some View {
        NavigationStack {
            listContent
                .navigationTitle("Counters")
                .overlay(alignment: .bottomTrailing) {
                    addMetricsButton
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack(spacing: 24) {
                            historyButton
                            settingsButton
                        }
                        .padding(8)
                    }
                }
                .sheet(isPresented: $showAddMetricsSheet) {
                    AddMetricsView()
                }
                .fullScreenCover(isPresented: $showGlobalHistorySheet) {
                    GlobalHistoryView()
                }
        }
    }
    
    private var listContent: some View {
        List(metrics) { metric in
            MetricCard(metric: metric)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color(uiColor: .systemGroupedBackground))
        }
        .listRowSpacing(16)
        .scrollContentBackground(.hidden)
        .listRowSeparator(.hidden)
        .buttonStyle(.borderless)
        .background(Color(uiColor: .systemGroupedBackground))
    }
    
    private var historyButton: some View {
        Button {
            showGlobalHistorySheet = true
        } label: {
            Image(systemName: "clock")
        }
    }
    
    private var settingsButton: some View {
        Button {
            
        } label: {
            Image(systemName: "gear")
        }
    }
    
    private var addMetricsButton: some View {
        Button {
            showAddMetricsSheet.toggle()
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(.white)
                .padding(16)
                .background(
                    Circle()
                        .fill(Color.blue.opacity(0.6))
                        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                )
        }
        .background(.ultraThinMaterial)
        .clipShape(Circle())
        .padding()
        .buttonStyle(PressedScaleButtonStyle())
    }
}

struct PressedScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.2 : 1.0)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}
