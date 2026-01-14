//
//  StatItemView.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI

/// A standard view for displaying a single statistic (Value + Label).
/// Used in StatsView and WorkoutStatsView.
struct StatItemView: View {
    let title: String
    let current: Int
    let total: Int
    var titleColor: Color = .secondary
    var valueColor: Color = .primary
    
    var body: some View {
        VStack {
            Text(title)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(titleColor)
            Text("\(current) of \(total)")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .fontWeight(.bold)
                .monospacedDigit()
                .foregroundColor(valueColor)
        }
    }
}

#Preview {
    StatItemView(title: "Sets", current: 1, total: 8)
}
