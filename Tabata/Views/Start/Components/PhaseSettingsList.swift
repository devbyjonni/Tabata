//  PhaseSettingsList.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI
import SwiftData

/// A vertical list of IntervalCards used to configure workout phases.
/// Includes cards for Warm Up, Work, Rest, and Cool Down.
struct PhaseSettingsList: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var configurations: [TabataConfiguration]
    
    var body: some View {
        guard let config = configurations.first else { return AnyView(EmptyView()) }
        
        return AnyView(
            VStack(spacing: 16) {
                IntervalCard(
                    phase: .warmUp,
                    color: Theme.warmup,
                    icon: Icons.warmUp.rawValue
                )
                
                IntervalCard(
                    phase: .work,
                    color: Theme.work,
                    icon: Icons.work.rawValue
                )
                
                IntervalCard(
                    phase: .rest,
                    color: Theme.rest,
                    icon: Icons.rest.rawValue
                )
                
                // Show "Rest Between Rounds" only if there are multiple rounds
                if config.rounds > 1 {
                    IntervalCard(
                        phase: .restBetweenRounds,
                        color: Theme.rest.opacity(0.8), // Slightly distinct
                        icon: Icons.hourglass.rawValue // Use our new icon
                    )
                }
                
                // Cool Down
                IntervalCard(
                    phase: .coolDown,
                    color: Theme.cooldown,
                    icon: Icons.cooldown.rawValue
                )
            }
            .padding(.top, 10)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: config.rounds > 1)
        )
    }
}
