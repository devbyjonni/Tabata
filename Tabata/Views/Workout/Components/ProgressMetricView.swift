//  ProgressMetricView.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI

/// A standard view for displaying a single statistic (Value + Label).
/// Used in StatsView and WorkoutStatsView.
struct ProgressMetricView: View {
    let title: String
    let current: Int
    let total: Int
    var titleColor: Color = .secondary
    var valueColor: Color = .primary
    var icon: String? = nil
    
    var body: some View {
        VStack(spacing: 4) {
             HStack(spacing: 6) {
                if let icon = icon {
                    Image(systemName: icon)
                        .renderingMode(.template)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                }
                Text(title)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
            }
            .foregroundColor(titleColor)
            
            Text("\(current) of \(total)")
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .fontWeight(.bold)
                .monospacedDigit()
                .foregroundColor(valueColor)
        }
    }
}
