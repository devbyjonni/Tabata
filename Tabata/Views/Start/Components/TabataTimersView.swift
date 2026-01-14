//
//  TabataTimersView.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI
import SwiftData

/// A list of IntervalCards for adjusting the duration of each workout phase.
/// covering Warm Up, Work, Rest, and Cool Down.
struct TabataTimersView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var configurations: [TabataConfiguration]
    
    // We keep viewModel local as logic handler
    private let viewModel: StartViewModel = StartViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            IntervalCard(
                title: WorkoutPhase.warmUp.rawValue,
                time: time(for: .warmUp),
                color: Theme.warmup,
                icon: Icons.warmUp.rawValue,
                onDecrement: { viewModel.adjustTime(for: .warmUp, by: -10, configurations: configurations) },
                onIncrement: { viewModel.adjustTime(for: .warmUp, by: 10, configurations: configurations) }
            )
            
            IntervalCard(
                title: WorkoutPhase.work.rawValue,
                time: time(for: .work),
                color: Theme.work,
                icon: Icons.work.rawValue,
                onDecrement: { viewModel.adjustTime(for: .work, by: -10, configurations: configurations) },
                onIncrement: { viewModel.adjustTime(for: .work, by: 10, configurations: configurations) }
            )
            
            IntervalCard(
                title: WorkoutPhase.rest.rawValue,
                time: time(for: .rest),
                color: Theme.rest,
                icon: Icons.rest.rawValue,
                onDecrement: { viewModel.adjustTime(for: .rest, by: -10, configurations: configurations) },
                onIncrement: { viewModel.adjustTime(for: .rest, by: 10, configurations: configurations) }
            )
            
            IntervalCard(
                title: WorkoutPhase.coolDown.rawValue,
                time: time(for: .coolDown),
                color: Theme.cooldown,
                icon: Icons.cooldown.rawValue,
                onDecrement: { viewModel.adjustTime(for: .coolDown, by: -10, configurations: configurations) },
                onIncrement: { viewModel.adjustTime(for: .coolDown, by: 10, configurations: configurations) }
            )
        }
        .padding(.top, 10)
    }
    
    private func time(for phase: WorkoutPhase) -> String {
        guard let configuration = configurations.first else { return "00:00" }
        
        let time: Double
        
        switch phase {
        case .warmUp: time = configuration.warmUpTime
        case .work: time = configuration.workTime
        case .rest: time = configuration.restTime
        case .coolDown: time = configuration.coolDownTime
        case .idle: time = 0
        }
        
        return time.formatTime()
    }
}

#Preview {
    TabataTimersView()
        .modelContainer(for: TabataConfiguration.self, inMemory: true)
}
