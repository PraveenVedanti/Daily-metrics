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
    
    // Show edit metrics view.
    @State private var showEditMetricsSheet = false
    
    // Color scheme environment variable
    @Environment(\.colorScheme) var colorScheme
   
    // Selected metric state variable.
    @State private var selectedMetric: Metric?
    
    // Alert shown before metric delete.
    @State private var showDeleteAlert = false
   
    // Metric to be deleted state variable
    @State private var metricToDelete: Metric? = nil
    
    // Model context for local data.
    @Environment(\.modelContext) private var modelContext
    
    // User defaults to track if tip is shown.
    @AppStorage("hasSeenSwipeTip") private var hasSeenSwipeTip = false
    
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
        ZStack(alignment: .bottom) {
            List(metrics) { metric in
                MetricCard(metric: metric)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
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
            .alert("Delete \(metricToDelete?.name ?? "Counter") ?", isPresented: $showDeleteAlert) {
                Button("Delete", role: .destructive) {
                    if let metric = metricToDelete {
                        deleteMetric(metric)
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This will permanently delete the counter and all its history.")
            }
            
            // Swipe Tip
            if metrics.count == 1 && !hasSeenSwipeTip {
                SwipeTipView {
                    withAnimation(.spring()) {
                        hasSeenSwipeTip = true
                    }
                }
                .padding(.bottom, 16)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
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


struct SwipeTipView: View {
    let onDismiss: () -> Void
    
    // Color scheme environment variable
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 12) {
            // Animated swipe icon
            Image(systemName: "hand.draw")
                .font(.title2)
                .foregroundStyle(.blue)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Swipe counter card more options")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text("Edit, reset or delete your counter")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            // Dismiss
            Button {
                onDismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                    .padding(6)
                    .background(Circle().fill(Color(.systemFill)))
            }
            .buttonStyle(.plain)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(colorScheme == .dark ? .secondarySystemBackground : .systemBackground))
                .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
        )
        .padding(.horizontal, 16)
    }
}
