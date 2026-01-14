//
//  WorkoutStatsView.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI

/// Shows real-time statistics during the workout (Sets, Rounds, Total Time).
/// Uses StatItemView for individual metrics.
struct WorkoutStatsView: View {
    var viewModel: WorkoutViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            // Set Card
            StatItemView(title: "SET", current: viewModel.currentSet, total: viewModel.totalSets, titleColor: .white.opacity(0.8), valueColor: .white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(Color.white.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            
            // Round Card
            StatItemView(title: "ROUND", current: viewModel.currentRound, total: viewModel.totalRounds, titleColor: .white.opacity(0.8), valueColor: .white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(Color.white.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        }
        .padding(.horizontal)
    }
}


