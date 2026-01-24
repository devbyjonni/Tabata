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
    
    var body: some View {
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
            
            IntervalCard(
                phase: .coolDown,
                color: Theme.cooldown,
                icon: Icons.cooldown.rawValue
            )
        }
        .padding(.top, 10)
    }
}
