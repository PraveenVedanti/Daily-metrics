//
//  SettingsView.swift
//  Daily-Metrics
//
//  Created by Praveen Kumar Vedanti on 3/10/26.
//

import SwiftData
import SwiftUI
import StoreKit

struct SettingsView: View {
    
// Alert shown before history clear.
@State private var showClearHistoryAlert = false
 
// Alert shown before all counter clear.
@State private var showClearAllCounterAlert = false

// MARK: - App Storage
@AppStorage("hapticsEnabled") private var hapticsEnabled: Bool = false
@AppStorage("soundEnabled") private var soundEnabled: Bool = false

// Model context.
@Environment(\.modelContext) private var modelContext
    
// All history
@Query var allHistory: [HistoryEntry]


// MARK: - Constants
private let contactEmail = "praveenkumarvedanti@gmail.com"

var body: some View {
    NavigationStack {
        List {
            
            // MARK: Feedback
            Section(DMStrings.feedbackSectionHeader) {
                Toggle(isOn: $hapticsEnabled) {
                    Label(DMStrings.hapticsText, systemImage: DMIcons.haptics)
                        .foregroundColor(.primary)
                }
                
                Toggle(isOn: $soundEnabled) {
                    Label(DMStrings.soundsText, systemImage: DMIcons.sounds)
                        .foregroundColor(.primary)
                }
            }
            
            // MARK: Support
            Section(DMStrings.supportSectionHeader) {
                Button {
                    requestReview()
                } label: {
                    Label(DMStrings.rateTheAppText, systemImage: DMIcons.star)
                        .foregroundColor(.primary)
                }
                
                Button {
                    sendEmail()
                } label: {
                    Label(DMStrings.feedbacktext, systemImage: DMIcons.envelope)
                        .foregroundColor(.primary)
                }
            }
            
            // MARK: Reset
            Section(DMStrings.dataSectionHeader) {
                // Clear history
                Button(role: .destructive) {
                    showClearHistoryAlert = true
                } label: {
                    Label(DMStrings.clearHistoryText, systemImage: DMIcons.trash)
                        .foregroundColor(allHistory.isEmpty ? .secondary : .orange)
                }
                
                // Delete all counters
                Button(role: .destructive) {
                    showClearAllCounterAlert = true
                } label: {
                    Label(DMStrings.deleteCountersTitle, systemImage: DMIcons.warning)
                        .foregroundColor(.red)
                }
            }
            
            // MARK: App Version
            Section {
                HStack {
                    Label(DMStrings.versionText, systemImage: DMIcons.info)
                        .foregroundColor(.primary)
                    Spacer()
                    Text(appVersion)
                        .foregroundColor(.secondary)
                }
            }
            
        }
        .navigationTitle(DMStrings.settingsNavigationTitle)
        .navigationBarTitleDisplayMode(.large)
        .alert(DMStrings.clearHistoryAlertTitle, isPresented: $showClearHistoryAlert) {
            Button(DMStrings.clearButtonTitle, role: .destructive) {
                clearAllHistory()
            }
            Button(DMStrings.cancelButtonTitle, role: .cancel) { }
        } message: {
            Text(DMStrings.clearHistoryAlertMessage)
        }.alert(DMStrings.deleteCountersAlertTitle, isPresented: $showClearAllCounterAlert) {
            Button(DMStrings.deleteAllButtonTitle, role: .destructive) {
                deleteAllMetrics()
            }
            Button(DMStrings.cancelButtonTitle, role: .cancel) { }
        } message: {
            Text(DMStrings.deleteCountersAlertMessage)
        }
    }
}

// MARK: - Helpers

    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        return "\(version)"
    }
    
    private func triggerHaptic() {
        guard hapticsEnabled else { return }
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    private func sendEmail() {
        let urlString = "mailto:\(contactEmail)?subject=Counters%20Feedback"
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    private func requestReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: {
            $0.activationState == .foregroundActive
        }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }

    private func clearAllHistory() {
        allHistory.forEach {
            modelContext.delete($0)
        }
        try? modelContext.save()
    }
    
    private func deleteAllMetrics() {
        do {
            try modelContext.delete(model: Metric.self)
            try modelContext.save()
        } catch {
            print("Failed to delete all metrics: \(error)")
        }
    }
}
