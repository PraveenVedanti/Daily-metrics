//
//  SettingsView.swift
//  Daily-Metrics
//
//  Created by Praveen Kumar Vedanti on 3/10/26.
//

import AVFoundation
import SwiftData
import SwiftUI
import StoreKit

struct SettingsView: View {

// MARK: - App Storage
@AppStorage("hapticsEnabled") private var hapticsEnabled: Bool = true
@AppStorage("soundEnabled") private var soundEnabled: Bool = true

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
            Section("Feedback") {
                Toggle(isOn: $hapticsEnabled) {
                    Label("Haptics", systemImage: "iphone.radiowaves.left.and.right")
                        .foregroundColor(.primary)
                }
                
                Toggle(isOn: $soundEnabled) {
                    Label("Sounds", systemImage: "speaker.wave.2")
                        .foregroundColor(.primary)
                }
            }
            
            // MARK: Data
            Section("Data") {
                Button(role: .destructive) {
                    showClearHistoryAlert = true
                } label: {
                    Label("Clear All History", systemImage: DMIcons.trashIcon)
                        .foregroundColor(allHistory.isEmpty ? .secondary : .red)
                }
            }
            
            // MARK: Support
            Section("Support") {
                Button {
                    requestReview()
                } label: {
                    Label("Rate the App", systemImage: "star")
                        .foregroundColor(.primary)
                }
                
                Button {
                    sendEmail()
                } label: {
                    Label("Contact / Feedback", systemImage: "envelope")
                        .foregroundColor(.primary)
                }
            }
            
            // MARK: App Version
            Section {
                HStack {
                    Label("Version", systemImage: "info.circle")
                    Spacer()
                    Text(appVersion)
                        .foregroundColor(.secondary)
                }
            }
            
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .alert("Clear All History", isPresented: $showClearHistoryAlert) {
            Button("Clear", role: .destructive) {
                clearAllHistory()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This will permanently delete the counter and all its history.")
        }
    }
}

// MARK: - Helpers

    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
    
    private func triggerHaptic() {
        guard hapticsEnabled else { return }
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    private func playSoundIfEnabled() {
        guard soundEnabled else { return }
        AudioServicesPlaySystemSound(1104) // Standard tap sound
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

// MARK: - Sound Helper (call this anywhere in the app)
// System sound IDs:
//   1104 — soft tap (increment)
//   1105 — tick (decrement)
//   1057 — pop (reset)

func playSoundIfEnabled(soundID: SystemSoundID = 1104) {
    let enabled = UserDefaults.standard.bool(forKey: "soundEnabled")
    guard enabled else { return }
    AudioServicesPlaySystemSound(soundID)
}
