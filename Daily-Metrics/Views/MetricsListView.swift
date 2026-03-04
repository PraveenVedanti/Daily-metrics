//
//  MetricsListView.swift
//  Daily-Metrics
//
//  Created by Praveen Kumar Vedanti on 3/2/26.
//

import Foundation
import SwiftUI

struct MetricsListView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State private var showAddMetricsSheet = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        MetricCard(metricTitle: "Reading", metricValue: 25, metricUnit: "pages")
                        MetricCard(metricTitle: "Reading", metricValue: 2, metricUnit: "pages")
                        MetricCard(metricTitle: "Reading", metricValue: 25, metricUnit: "pages")
                        MetricCard(metricTitle: "Reading", metricValue: 25, metricUnit: "pages")
                    }
                    .padding()
                }
            }
            .navigationTitle("Counters")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    addMetricsButton
                }
            }
            .sheet(isPresented: $showAddMetricsSheet) {
                AddMetricsView()
            }
        }
    }
    
    private var addMetricsButton: some View {
        Button {
            showAddMetricsSheet.toggle()
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 20, weight: .semibold))
        }
    }
}
