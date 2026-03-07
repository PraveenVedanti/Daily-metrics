//
//  GlobalHistoryView.swift
//  Daily-Metrics
//
//  Created by Praveen Kumar Vedanti on 3/6/26.
//

import Foundation
import SwiftUI
import SwiftData

struct GlobalHistoryView: View {
    @Query(sort: \HistoryEntry.timestamp, order: .reverse)
    var allHistory: [HistoryEntry]
    
    // Dismiss the view
    @Environment(\.dismiss) var dismiss

    // Group entries into date sections
    var groupedHistory: [(title: String, entries: [HistoryEntry])] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let weekStart = calendar.date(byAdding: .day, value: -7, to: today)!
        let monthStart = calendar.date(byAdding: .month, value: -1, to: today)!

        let sections: [(title: String, filter: (HistoryEntry) -> Bool)] = [
            ("Today",     { $0.timestamp >= today }),
            ("Yesterday", { $0.timestamp >= yesterday && $0.timestamp < today }),
            ("This Week", { $0.timestamp >= weekStart && $0.timestamp < yesterday }),
            ("This Month",{ $0.timestamp >= monthStart && $0.timestamp < weekStart }),
            ("Older",     { $0.timestamp < monthStart })
        ]

        return sections.compactMap { section in
            let filtered = allHistory.filter(section.filter)
            guard !filtered.isEmpty else { return nil }  // skip empty sections
            return (title: section.title, entries: filtered)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(groupedHistory, id: \.title) { section in
                    Section(header: Text(section.title)) {
                        ForEach(section.entries) { entry in
                            HStack(spacing: 16) {
                                
                                // Color of the counter
                                Circle()
                                    .fill(color(from: entry.metric?.color ?? "blue"))
                                    .frame(width: 16, height: 16)
                                
                                // Counter name and date.
                                VStack(alignment: .leading) {
                                    Text(entry.metric?.name ?? "Deleted")
                                        .fontWeight(.semibold)
                                    Text(entry.timestamp.formatted(date: .abbreviated, time: .shortened))
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()

                                // Counter value change.
                                Text(entry.change > 0 ? "+\(entry.change)" : "\(entry.change)")
                                    .fontWeight(.bold)
                                    .foregroundStyle(entry.change > 0 ? .green : .red)
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("All History")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func color(from string: String) -> Color {
        switch string.lowercased() {
        case "red":
            return .red
        case "green":
            return .green
        case "yellow":
            return .yellow
        case "blue":
            return .blue
        case "orange":
            return .orange
        case "brown":
            return .brown
        default:
            return .blue
        }
    }
}
