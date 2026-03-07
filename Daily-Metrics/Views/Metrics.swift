//
//  Metrics.swift
//  Daily-Metrics
//
//  Created by Praveen Kumar Vedanti on 3/6/26.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Metric {
    var id: UUID
    var name: String
    var desc: String?
    var unit: String?
    var value: Int
    var increment: Int
    var color: String?
    var createdAt: Date
    
    @Relationship(deleteRule: .cascade, inverse: \HistoryEntry.metric)
    var history: [HistoryEntry] = []

    init(
        name: String,
        desc: String? = nil,
        unit: String? = nil,
        value: Int = 0,
        increment: Int = 1,
        color: String? = "blue"
    ) {
        self.id = UUID()
        self.name = name
        self.desc = desc
        self.unit = unit
        self.value = value
        self.increment = increment
        self.color = color
        self.createdAt = Date()
    }
}


@Model
final class HistoryEntry {
    var id: UUID
    var timestamp: Date
    var change: Int
    var valueAfter: Int
    var metric: Metric?
    
    init(
        change: Int,
        valueAfter: Int,
        metric: Metric? = nil
    ) {
        self.id = UUID()
        self.timestamp = Date()
        self.change = change
        self.valueAfter = valueAfter
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
        value += delta
        let entry = HistoryEntry(change: delta, valueAfter: value, metric: self)
        context.insert(entry)
    }
    
    /// Decrement and record history
    func decrement(by delta: Int = 1, in context: ModelContext) {
        value -= delta
        let entry = HistoryEntry(change: -delta, valueAfter: value, metric: self)
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


enum CounterMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [CounterSchemaV1.self, CounterSchemaV2.self]
    }

    static var stages: [MigrationStage] {
        [migrateV1toV2]
    }

    // Lightweight = no data transformation needed, just new model added
    static let migrateV1toV2 = MigrationStage.lightweight(
        fromVersion: CounterSchemaV1.self,
        toVersion: CounterSchemaV2.self
    )
}

// Your original schema (Counter only)
enum CounterSchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)
    static var models: [any PersistentModel.Type] { [Metric.self] }
}

// New schema (Counter + HistoryEntry)
enum CounterSchemaV2: VersionedSchema {
    static var versionIdentifier = Schema.Version(2, 0, 0)
    static var models: [any PersistentModel.Type] { [Metric.self, HistoryEntry.self] }
}
