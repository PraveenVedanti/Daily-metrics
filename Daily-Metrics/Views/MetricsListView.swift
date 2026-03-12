//
//  MetricsListView.swift
//  Daily-Metrics
//
//  Created by Praveen Kumar Vedanti on 3/2/26.
//

import Foundation
import SwiftData
import SwiftUI

// MARK: - Metrics list view.

struct MetricsListView: View {
    
    // Show add metrics view.
    @State private var showAddMetricsSheet = false
    
    @State private var showEditMetricsSheet = false
    
    @Environment(\.colorScheme) var colorScheme
   
    @State private var selectedMetric: Metric?
    
    @State private var showDeleteAlert = false
    @State private var metricToDelete: Metric? = nil
    
    // Model context for local data.
    @Environment(\.modelContext) private var modelContext
    
    // Query to fetch counters list.
    @Query(sort: \Metric.name, order: .reverse)
    
    // List of metrics created.
    private var metrics: [Metric]
    
    var body: some View {
        NavigationStack {
            homeContent
                .navigationTitle(metrics.isEmpty ? "" : "Counters")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                       addMetricsButton
                    }
                }
                .sheet(isPresented: $showAddMetricsSheet) {
                    AddMetricsView()
                }
                .sheet(item: $selectedMetric) { metric in
                    EditCounterView(metric: metric)
                }
        }
    }
    
    @ViewBuilder
    private var homeContent: some View {
        if metrics.isEmpty {
            zeroStateContent
        } else {
            listContent
        }
    }
    
    // Zero state
    private var zeroStateContent: some View {
        VStack(spacing: 16) {
            
            // Title
            Text("No Counters Yet")
                .font(.system(size: 22, weight: .bold, design: .default))
                .foregroundStyle(.primary)
            
            // Subtitle
            Text("Create your first counter to start.")
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
            
            // CTA Button
            Button(action: {
                showAddMetricsSheet.toggle()
            }, label: {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.system(size: 17, weight: .medium))
                    Text("New Counter")
                        .font(.system(size: 16, weight: .semibold))
                }
            })
            .buttonStyle(.plain)
            .foregroundStyle(.white)
            .padding(.horizontal, 28)
            .padding(.vertical, 16)
            .background(Color.counterLightBlue, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: .black.opacity(0.18), radius: 10, x: 0, y: 4)
            
            HStack(spacing: 5) {
                Image(systemName: "info.circle")
                    .font(.system(size: 13))
                Text("You can also tap + in the top right")
                    .font(.system(size: 13))
            }
            .foregroundStyle(Color(.systemGray3))
            .padding(.top, 4)
        }
    }
    
    private var listContent: some View {
        List(metrics) { metric in
            MetricCard(metric: metric)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color(uiColor: .systemGroupedBackground))
                .swipeActions {
                    Button {
                        metricToDelete = metric
                        showDeleteAlert = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    .tint(.red)
                    
                    Button {
                    } label: {
                        Label("Reset", systemImage: "arrow.counterclockwise")
                    }
                    .tint(.orange)
                    
                    Button {
                        selectedMetric = metric
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    .tint(.blue)
                }
        }
        .listRowSpacing(16)
        .scrollContentBackground(.hidden)
        .listRowSeparator(.hidden)
        .background(Color(uiColor: .systemGroupedBackground))
        .alert("Delete \(metricToDelete?.name ?? "Counter")?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let metric = metricToDelete {
                    deleteMetric(metric)
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This will permanently delete the counter and all its history.")
        }
    }
    
    private var addMetricsButton: some View {
        Button {
            showAddMetricsSheet.toggle()
        } label: {
            Image(systemName: "plus")
        }
    }
    
    private func deleteMetric(_ metric: Metric) {
        modelContext.delete(metric)
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to delete metric: \(error)")
        }
    }
}
