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
    
    // Alert shown before metric reset.
    @State private var showResetAlert = false
    
    // Metric to be reset state variable
    @State private var metricToReset: Metric? = nil
    
    // Search text.
    @State private var searchText = ""
    
    // State variable to see if searching.
    @State private var isSearching = false
    
    // Model context for local data.
    @Environment(\.modelContext) private var modelContext
    
    // User defaults to track if tip is shown.
    @AppStorage("hasSeenSwipeTip") private var hasSeenSwipeTip = false
    
    // Query to fetch counters list.
    @Query(sort: \Metric.sortOrder) var metrics: [Metric]
    
    var body: some View {
        NavigationStack {
            homeContent
                .navigationTitle(metrics.isEmpty ? "" : "Counters")
                .searchableIfNeeded(text: $searchText, isPresented: $isSearching)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        HStack(spacing: 32) {
                            if !metrics.isEmpty {
                                searchButton
                            }
                            addMetricsButton
                        }
                        .padding(.horizontal, 8)
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        if !metrics.isEmpty && !isSearching {
                            EditButton()
                        }
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
            Text(DMStrings.emptyStateTitle)
                .font(.system(size: 22, weight: .bold, design: .default))
                .foregroundStyle(.primary)
            
            // Subtitle
            Text(DMStrings.emptyStateMessage)
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
            
            // CTA Button
            Button(action: {
                showAddMetricsSheet.toggle()
            }, label: {
                HStack(spacing: 8) {
                    Image(systemName: DMIcons.plus)
                        .font(.system(size: 16, weight: .medium))
                    Text(DMStrings.newCountersButtonTitle)
                        .font(.system(size: 16, weight: .semibold))
                }
            })
            .buttonStyle(.plain)
            .foregroundStyle(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(Color.accentColor, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: .black.opacity(0.18), radius: 10, x: 0, y: 4)
            .accessibilityLabel(DMStrings.newCountersButtonTitle)
            .accessibilityHint("Opens a sheet to add a new metric")
            .accessibilityAddTraits(.isButton)
            
            HStack(spacing: 5) {
                Image(systemName: DMIcons.info)
                    .font(.system(size: 13))
                Text(DMStrings.emptyStateHint)
                    .font(.system(size: 13))
            }
            .foregroundStyle(Color(.systemGray3))
            .padding(.top, 4)
        }
    }
    
    private var listContent: some View {
        ZStack(alignment: .bottom) {
            List {
                ForEach(filteredMetrics) { metric in
                    MetricCard(metric: metric)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6))
                        .listRowBackground(Color(uiColor: .systemGroupedBackground))
                        .contextMenu {
                            metricActionButton(.edit, metric: metric) {
                                selectedMetric = metric
                            }

                            metricActionButton(.reset, metric: metric, tint: .orange.opacity(0.6)) {
                                metricToReset = metric
                                showResetAlert = true
                            }

                            metricActionButton(.delete, metric: metric, role: .destructive, tint: .red) {
                                metricToDelete = metric
                                showDeleteAlert = true
                            }
                        }
                        .swipeActions {
                            metricActionButton(.delete, metric: metric, role: .destructive, tint: .red) {
                                metricToDelete = metric
                                showDeleteAlert = true
                            }

                            metricActionButton(.reset, metric: metric, tint: .orange.opacity(0.6)) {
                                metricToReset = metric
                                showResetAlert = true
                            }

                            metricActionButton(.edit, metric: metric, tint: .secondary) {
                                selectedMetric = metric
                            }
                        }
                }
                .onMove { from, to in
                    guard searchText.isEmpty else { return }
                    var reordered = metrics
                    reordered.move(fromOffsets: from, toOffset: to)
                    for (index, metric) in reordered.enumerated() {
                        metric.sortOrder = index
                    }
                    DispatchQueue.main.async {
                        try? modelContext.save()
                    }
                }
            }
            .listRowSpacing(16)
            .scrollContentBackground(.hidden)
            .listRowSeparator(.hidden)
            .background(Color(uiColor: .systemGroupedBackground))
            .alert("Delete \(metricToDelete?.name ?? "Counter") ?", isPresented: $showDeleteAlert) {
                Button(DMStrings.deleteButtonTitle
                       , role: .destructive) {
                    if let metric = metricToDelete {
                        deleteMetric(metric)
                    }
                }
                Button(DMStrings.cancelButtonTitle, role: .cancel) { }
            } message: {
                Text(DMStrings.deleteCounterAlertMessage)
            }
            .alert("Reset \(metricToReset?.name ?? "Counter") ?", isPresented: $showResetAlert) {
                Button(DMStrings.resetButtonTitle, role: .destructive) {
                    if let metric = metricToReset {
                        reset(in: modelContext, metric: metric)
                    }
                }
                Button(DMStrings.cancelButtonTitle, role: .cancel) { }
            } message: {
                Text(DMStrings.resetCounterAlertMessage)
            }
            
            // Search unavailable view.
            if !searchText.isEmpty && filteredMetrics.isEmpty {
                ContentUnavailableView.search(text: searchText)
            }

            // Swipe Tip
            if metrics.count == 1 && !hasSeenSwipeTip {
                VStack {
                    SwipeTipView() {
                        withAnimation(.spring()) {
                            hasSeenSwipeTip = true
                        }
                    }
                    .padding(.bottom, 16)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
    }
    
    enum MetricAction {
        case edit
        case reset
        case delete

        var title: String {
            switch self {
            case .edit: return DMStrings.editButtonTitle
            case .reset: return DMStrings.resetButtonTitle
            case .delete: return DMStrings.deleteButtonTitle
            }
        }

        var icon: String {
            switch self {
            case .edit: return DMIcons.edit
            case .reset: return DMIcons.reset
            case .delete: return DMIcons.trash
            }
        }

        var hint: String {
            switch self {
            case .edit: return "Edit this counter"
            case .reset: return "This will reset the counter back to 0"
            case .delete: return "This will permanently delete the counter"
            }
        }
    }
    
    @ViewBuilder
    private func metricActionButton(
        _ action: MetricAction,
        metric: Metric,
        role: ButtonRole? = nil,
        tint: Color? = nil,
        actionHandler: @escaping () -> Void
    ) -> some View {
        Button(role: role) {
            actionHandler()
        } label: {
            Label(action.title, systemImage: action.icon)
                .accessibilityHidden(true) // icon hidden from VoiceOver
        }
        .accessibilityLabel(NSLocalizedString(
            "\(action.title) \(metric.name)",
            comment: "Accessibility label for \(action.title.lowercased()) counter button"
        ))
        .accessibilityHint(NSLocalizedString(
            action.hint,
            comment: "Accessibility hint for \(action.title.lowercased()) counter button"
        ))
        .accessibilityAddTraits(.isButton)
        .tint(tint)
    }
    
    private var addMetricsButton: some View {
        Button {
            showAddMetricsSheet.toggle()
        } label: {
            Image(systemName: DMIcons.plus)
                .accessibilityHidden(true)
        }
        .accessibilityLabel("Add Counter")
        .accessibilityHint("Creates a new counter")
    }
    
    private var searchButton: some View {
        Button {
            withAnimation {
                isSearching = true
            }
        } label: {
            Image(systemName: DMIcons.search)
                .accessibilityHidden(true)
        }
    }
    
    var filteredMetrics: [Metric] {
        if searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            return metrics
        }
        return metrics.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
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
    
    func reset(in context: ModelContext, metric: Metric) {
        let before = metric.value
        metric.value = 0
        let entry = HistoryEntry(change: 0, valueBefore: before, valueAfter: 0, metric: metric)
        context.insert(entry)
    }
}

// MARK: - Swipe tip view.
struct SwipeTipView: View {
    let onDismiss: () -> Void
    
    // Color scheme environment variable
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 12) {
            // Animated swipe icon
            Image(systemName: DMIcons.handDraw)
                .font(.title2)
                .foregroundStyle(.blue)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(DMStrings.swipeTipViewTitle)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(DMStrings.swipeTipViewSubTitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            // Dismiss
            Button {
                onDismiss()
            } label: {
                Image(systemName: DMIcons.crossMark)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                    .padding(6)
                    .background(Circle().fill(Color(.systemFill)))
            }
            .accessibilityLabel("Dismiss")
            .accessibilityHint("Closes this view")
            .accessibilityAddTraits(.isButton)
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


extension View {
    @ViewBuilder
    func searchableIfNeeded(text: Binding<String>, isPresented: Binding<Bool>) -> some View {
        if isPresented.wrappedValue {
            self.searchable(
                text: text,
                isPresented: isPresented,
                placement: .navigationBarDrawer(displayMode: .always)
            )
        } else {
            self
        }
    }
}
