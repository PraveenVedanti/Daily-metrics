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

// MARK: - App Storage
@AppStorage("hapticsEnabled") private var hapticsEnabled: Bool = true
@AppStorage("soundEnabled") private var soundEnabled: Bool = false

// MARK: - State
@State private var showClearHistoryConfirmation = false
    
@Environment(\.modelContext) private var modelContext
@Query var allHistory: [HistoryEntry]

@State private var showClearHistoryAlert = false

// MARK: - Constants
private let contactEmail = "praveenvedanti11@gmail.com"
private let privacyPolicyURL = "https://your-privacy-policy-url.com"
private let appStoreID = "YOUR_APP_STORE_ID" // Replace with your App Store ID

var body: some View {
    NavigationStack {
        List {
            
            // MARK: Feedback
            Section(DMStrings.feedbackSectionHeader) {
                Toggle(isOn: $hapticsEnabled) {
                    Label(DMStrings.hapticsText, systemImage: DMIcons.hapticsIcon)
                        .foregroundColor(.primary)
                }
                
                Toggle(isOn: $soundEnabled) {
                    Label(DMStrings.soundsText, systemImage: DMIcons.soundsIcon)
                        .foregroundColor(.primary)
                }
            }
            
            // MARK: Data
            Section(DMStrings.dataSectionHeader) {
                Button(role: .destructive) {
                    showClearHistoryAlert = true
                } label: {
                    Label(DMStrings.clearHistoryText, systemImage: DMIcons.trashIcon)
                        .foregroundColor(allHistory.isEmpty ? .secondary : .red)
                }
            }
            
            // MARK: Support
            Section(DMStrings.supportSectionHeader) {
                Button {
                    requestReview()
                } label: {
                    Label(DMStrings.rateTheAppText, systemImage: DMIcons.starIcon)
                        .foregroundColor(.primary)
                }
                
                Button {
                    sendEmail()
                } label: {
                    Label(DMStrings.feedbacktext, systemImage: DMIcons.envelopeIcon)
                        .foregroundColor(.primary)
                }
            }
            
            // MARK: App Version
            Section {
                HStack {
                    Label(DMStrings.versionText, systemImage: DMIcons.infoIcon)
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
            Button("Clear", role: .destructive) {
                clearAllHistory()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text(DMStrings.clearHistoryAlertMessage)
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
        let urlString = "mailto:\(contactEmail)?subject=CountUp%20Feedback"
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
}
