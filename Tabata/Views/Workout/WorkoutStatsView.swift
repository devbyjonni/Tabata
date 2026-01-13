//
//  WorkoutStatsView.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI

struct WorkoutStatsView: View {
    var viewModel: WorkoutViewModel
    
    var body: some View {
        HStack {
            Spacer()
            StatItemView(title: "Sets", current: viewModel.currentSet, total: viewModel.totalSets)
            Spacer()
            StatItemView(title: "Rounds", current: viewModel.currentRound, total: viewModel.totalRounds)
            Spacer()
        }
    }
}

#Preview {
    WorkoutStatsView(viewModel: WorkoutViewModel())
}
