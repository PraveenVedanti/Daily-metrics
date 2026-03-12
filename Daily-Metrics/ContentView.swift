//
//  ContentView.swift
//  Daily-Metrics
//
//  Created by Praveen Kumar Vedanti on 3/2/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {

    var body: some View {
        TabView {
            MetricsListView()
                .tabItem {
                    Label("Counters", systemImage: "list.bullet.rectangle")
                }
            
            GlobalHistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
            
            
        }
    }
}
