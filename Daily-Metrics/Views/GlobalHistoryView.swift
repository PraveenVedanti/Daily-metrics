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
                .listRowInsets(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4))
                .listRowBackground(Color.clear)
                
                // History Sections
                ForEach(groupedHistory, id: \.title) { section in
                    Section(header: Text(section.title)) {
                        ForEach(section.entries) { entry in
                            HStack(spacing: 12) {
                                
                                // Color of the counter
                                Circle()
                                    .fill(ColorToken.stringToColor(entry.metric?.color ?? "counterBlue"))
                                    .frame(width: 16, height: 16)
                                
                                // Counter name and date.
                                VStack(alignment: .leading) {
                                    Text(entry.metric?.name ?? "Deleted")
                                        .fontWeight(.semibold)
                                    Text(entry.timestamp.formatted(date: .abbreviated, time: .shortened))
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                
                                // Before → After
                                HStack(spacing: 4) {
                                    Text("\(entry.valueBefore)")
                                        .foregroundStyle(.secondary)
                                    Image(systemName: "arrow.right")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    Text("\(entry.valueAfter)")
                                        .fontWeight(.semibold)
                                }
                                .font(.subheadline)
                                
                                // Counter value change.
                                Text(entry.change > 0 ? "+\(entry.change)" : "\(entry.change)")
                                    .fontWeight(.bold)
                                    .foregroundStyle(entry.change > 0 ? .green : .red)
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
        }
    }
    
    private func calculateIncrement(metric: Metric) -> Int {
        return metric.value * metric.increment
    }
    
    private var filteringPills: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterPill(title: "All", isSelected: selectedCounter == nil) {
                    selectedCounter = nil
                }
                ForEach(counterNames, id: \.self) { name in
                    FilterPill(title: name, isSelected: selectedCounter == name) {
                        selectedCounter = (selectedCounter == name) ? nil : name
                    }
                }
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 4)
        }
    }
}

// MARK: - Filter pill.

struct FilterPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(isSelected ? Color.accentColor : Color(.secondarySystemGroupedBackground))
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .strokeBorder(isSelected ? Color.clear : Color(.separator), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}
