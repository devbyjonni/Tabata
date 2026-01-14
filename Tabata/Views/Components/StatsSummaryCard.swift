//
//  StatsSummaryCard.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-14.
//

import SwiftUI

/// A generic card component for displaying a summary statistic (e.g. Total Workouts, Total Duration).
struct StatsSummaryCard: View {
    let title: String
    let value: String
    let icon: String
    let iconColor: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .tracking(1)
                    .foregroundStyle(Color.slate400)
                    .textCase(.uppercase)
                
                Text(value)
                    .font(.system(size: 40, weight: .black, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(.white)
            }
            Spacer()
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundStyle(iconColor)
        }
        .padding(24)
        .background(Color.slate800)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .shadow(color: .clear, radius: 10, x: 0, y: 4)
    }
}
