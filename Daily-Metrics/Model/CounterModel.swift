//
//  CounterModel.swift
//  Daily-Metrics
//
//  Created by Praveen Kumar Vedanti on 3/8/26.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Metric {
    var id: UUID
    var name: String
    var value: Int
    var increment: Int
    var color: String?
    var desc: String?
    var createdAt: Date
    var target: Int?
    var hasTarget: Bool?
    
    var sortOrder: Int = 0
    
    @Relationship(deleteRule: .cascade, inverse: \HistoryEntry.metric)
    var history: [HistoryEntry] = []

    init(
        name: String,
        value: Int = 0,
        increment: Int = 1,
        color: String? = "counterBlue",
        target: Int? = nil,
        desc: String? = nil,
        hasTarget: Bool? = false
    ) {
        self.id = UUID()
        self.name = name
        self.value = value
        self.increment = increment
        self.color = color
        self.target = target
        self.desc = desc
        self.hasTarget = hasTarget
        self.createdAt = Date()
    }
}


@Model
final class HistoryEntry {
    var id: UUID
    var timestamp: Date
    var change: Int
    var valueBefore: Int
    var valueAfter: Int
    var metric: Metric?
    
    init(
        change: Int,
        valueBefore: Int,
        valueAfter: Int,
        metric: Metric? = nil
    ) {
        self.id = UUID()
        self.timestamp = Date()
        self.change = change
        self.valueAfter = valueAfter
        self.valueBefore = valueBefore
        self.metric = metric
    }
}

extension ModelContainer {
    static var appContainer: ModelContainer = {
        let schema = Schema([
            Metric.self,
            HistoryEntry.self
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Failed to create ModelContainer: (error)")
        }
    }()
}


// MARK: - Counter + History Helpers

extension Metric {
    
    /// Increment and record history
    func increment(by delta: Int = 1, in context: ModelContext) {
        let before = value
        value += (delta * increment)
        let entry = HistoryEntry(change: delta, valueBefore: before, valueAfter: value, metric: self)
        context.insert(entry)
    }
    
    /// Decrement and record history
    func decrement(by delta: Int = 1, in context: ModelContext) {
        let before = value
        value -= (delta * increment)
        let entry = HistoryEntry(change: -delta, valueBefore: before, valueAfter: value, metric: self)
        context.insert(entry)
    }
    
    /// Sorted history, newest first
    var sortedHistory: [HistoryEntry] {
        history.sorted { $0.timestamp > $1.timestamp }
    }
    
    /// Today's entries only
    var todayHistory: [HistoryEntry] {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        return history.filter { $0.timestamp >= startOfDay }
    }
    
    /// Net change today
    var todayNetChange: Int {
        todayHistory.reduce(0) { $0 + $1.change }
    }
}

extension HistoryEntry {
    var actualChange: Int {
        valueAfter - valueBefore
    }
}


// Your original schema (Counter only)
enum CounterSchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)
    static var models: [any PersistentModel.Type] { [Metric.self, HistoryEntry.self] }
}
