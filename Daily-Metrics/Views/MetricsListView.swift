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
    
    // Show add metrics sheet.
    @State private var showAddMetricsSheet = false
    
    // Show global history sheet.
    @State private var showGlobalHistorySheet = false
    
    // Query to fetch counters list.
    @Query(sort: \Metric.name, order: .reverse)
    
    // List of metrics created.
    private var metrics: [Metric]
    
    var body: some View {
        NavigationStack {
            homeContent
                .navigationTitle("Counters")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack(spacing: 24) {
                            historyButton
                            settingsButton
                            addMetricsButton
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
    
    @ViewBuilder
    private var homeContent: some View {
        if metrics.isEmpty {
            emptyStateContent
        } else {
            listContent
        }
    }
    
    private var emptyStateContent: some View {
        VStack(spacing: 16) {
            
            // Title
            Text("No Counters Yet")
                .font(.system(size: 22, weight: .bold, design: .default))
                .foregroundStyle(.primary)
            
            // Subtitle
            Text("Create your first counter to start\ntracking anything — steps, cups of\nwater, reps, and more.")
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
            .background(Color.secondary, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
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
        }
        .listRowSpacing(16)
        .scrollContentBackground(.hidden)
        .listRowSeparator(.hidden)
        .buttonStyle(.borderless)
        .background(Color(uiColor: .systemGroupedBackground))
    }
    
    private var zeroStateView: some View {
        VStack {
            Text("No Counters Yet")
        }
    }
    
    private var historyButton: some View {
        Button {
            showGlobalHistorySheet = true
        } label: {
            Image(systemName: "clock")
        }
        .disabled(metrics.isEmpty)
    }
    
    private var settingsButton: some View {
        Button {
            
        } label: {
            Image(systemName: "gear")
        }
        .disabled(metrics.isEmpty)
    }
    
    private var addMetricsButton: some View {
        Button {
            showAddMetricsSheet.toggle()
        } label: {
            Image(systemName: "plus")
        }
    }
}
