//
//  RectangleProgressView.swift
//  Daily-Metrics
//
//  Created by Praveen Kumar Vedanti on 3/29/26.
//

import Foundation
import SwiftUI


struct CustomProgressBar: View {
    var progress: Double
    var color: Color

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(height: 8)
                    .foregroundColor(.gray.opacity(0.3))
                    .cornerRadius(6)

                Rectangle()
                    .frame(width: geo.size.width * progress, height: 8)
                    .foregroundColor(color)
                    .cornerRadius(6)
                    .animation(.easeInOut, value: progress)
            }
        }
        //.frame(height: 6)
        .padding(.bottom)
        .padding(.horizontal)
    }
}
