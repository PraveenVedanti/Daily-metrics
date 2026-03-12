//
//  GlobalHistoryView.swift
//  Daily-Metrics
//
//  Created by Praveen Kumar Vedanti on 3/6/26.
//

import Foundation
import SwiftUI
import SwiftData

// MARK: - Global history view.
 
struct GlobalHistoryView: View {
    
    // Environment variable to dismiss screen
    @Environment(\.dismiss) var dismiss
    
    @Query(sort: \HistoryEntry.timestamp, order: .reverse)
    
    // All history list.
    var allHistory: [HistoryEntry]
    
    // Selected counter state variable.
    @State private var selectedCounter: String? = nil
    
    // Sorted list of counter names.
    var counterNames: [String] {
        let names = allHistory.compactMap { $0.metric?.name }
        return Array(Set(names)).sorted()
    }
    
    // Filtered history list of counters
    var filteredHistory: [HistoryEntry] {
        guard let selected = selectedCounter else { return allHistory }
        return allHistory.filter { $0.metric?.name == selected }
    }
    
    var groupedHistory: [(title: String, entries: [HistoryEntry])] {
        let calendar = Calendar.current
        let now = Date()
        
        let grouped = Dictionary(grouping: filteredHistory) { entry -> String in
            if calendar.isDateInToday(entry.timestamp) {
                return "Today"
            } else if calendar.isDateInYesterday(entry.timestamp) {
                return "Yesterday"
            } else if let daysAgo = calendar.dateComponents([.day], from: entry.timestamp, to: now).day, daysAgo < 7 {
                return entry.timestamp.formatted(.dateTime.weekday(.wide))
            } else {
                return entry.timestamp.formatted(.dateTime.month(.wide).year())
            }
        }
        
        let order = ["Today", "Yesterday"]
        return grouped
            .map { (title: $0.key, entries: $0.value) }
            .sorted { a, b in
                let aIndex = order.firstIndex(of: a.title)
                let bIndex = order.firstIndex(of: b.title)
                if let ai = aIndex, let bi = bIndex { return ai < bi }
                if aIndex != nil { return true }
                if bIndex != nil { return false }
                return (a.entries.first?.timestamp ?? .distantPast) > (b.entries.first?.timestamp ?? .distantPast)
            }
    }
    
    var body: some View {
        NavigationStack {
            
            List {
                
                // Filter Pills
                Section {
                    filteringPills
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                
                // History Sections
                ForEach(groupedHistory, id: \.title) { section in
                    Section(header: Text(section.title)) {
                        ForEach(section.entries) { entry in
                            HStack(spacing: 12) {
                                
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .fill(ColorToken.stringToColor(entry.metric?.color ?? "counterBlue"))
                                    .frame(width: 4)
                                
                                // Counter name and date.
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(entry.metric?.name ?? "Deleted")
                                        .fontWeight(.semibold)
                                    Text(entry.timestamp.formatted(date: .omitted, time: .shortened))
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 6) {
                                    // Counter value change.
                                    Text(entry.actualChange > 0 ? "+\(entry.actualChange)" : "\(entry.actualChange)")
                                        .fontWeight(.bold)
                                        .foregroundStyle(entry.actualChange > 0 ? .green : .red)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(
                                            Capsule()
                                                .fill(entry.actualChange > 0 ? Color.green.opacity(0.15) : Color.red.opacity(0.15))
                                        )
                                    
                                    
                                    // Before → After
                                    HStack(spacing: 4) {
                                        Text("\(entry.valueBefore)")
                                            .foregroundStyle(.secondary)
                                        Image(systemName: "arrow.right")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                        Text("\(entry.valueAfter)")
                                            .fontWeight(.regular)
                                            .foregroundStyle(.secondary)
                                    }
                                    .font(.subheadline)
                                    
                                    
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    
    private func calculateIncrement(metric: Metric) -> Int {
        return metric.value * metric.increment
    }
    
    private var filteringPills: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                FilterPill(title: "All", isSelected: selectedCounter == nil) {
                    selectedCounter = nil
                }
                ForEach(counterNames, id: \.self) { name in
                    FilterPill(title: name, isSelected: selectedCounter == name) {
                        selectedCounter = (selectedCounter == name) ? nil : name
                    }
                }
            }
            .padding(4)
            .padding(.horizontal, 4)
        }
    }
}

// MARK: - Filter pill.
struct FilterPill: View {
    
    @Environment(\.colorScheme) var colorScheme

    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundStyle(isSelected ? .primary : .secondary)
                .tracking(0.2)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.secondary.opacity(colorScheme == .dark ? 0.4 : 0.1) : Color.clear)
                    }
        }
        .buttonStyle(.plain)
    }
}
