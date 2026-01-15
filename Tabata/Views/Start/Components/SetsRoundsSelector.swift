//  SetsRoundsSelector.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI
import SwiftData

/// Controls for setting the number of Sets and Rounds.
/// Also includes the global Sound Toggle control.
struct SetsRoundsSelector: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var configurations: [TabataConfiguration]
    @Query private var settings: [TabataSettings]
    
    private var viewModel: StartViewModel = StartViewModel()
    
    var body: some View {
        HStack {
            // Sets
            CounterControl(
                label: "SETS",
                value: "\(configurations.first?.sets ?? 0)",
                onDecrement: { viewModel.updateSets(by: -1, configurations: configurations) },
                onIncrement: { viewModel.updateSets(by: 1, configurations: configurations) }
            )
            
            // Speaker
            ControlButton(
                icon: (settings.first?.isSoundEnabled ?? true) ? Icons.speaker.rawValue : Icons.speakerSlash.rawValue,
                backgroundColor: Color.slate800,
                foregroundColor: Color.white.opacity(0.5),
                size: 44,
                iconSize: 16
            ) {
                if let currentSettings = settings.first {
                    currentSettings.isSoundEnabled.toggle()
                    
                    // Safety: If enabling sound but volume is 0, reset to 50%
                    if currentSettings.isSoundEnabled && currentSettings.volume == 0 {
                        currentSettings.volume = 0.5
                        SoundManager.shared.volume = 0.5
                    }
                    
                    SoundManager.shared.isSoundEnabled = currentSettings.isSoundEnabled
                    HapticManager.shared.play(.light)
                }
            }
            .offset(y: 40)
            
            // Rounds
            CounterControl(
                label: "ROUNDS",
                value: "\(configurations.first?.rounds ?? 0)",
                onDecrement: { viewModel.updateRounds(by: -1, configurations: configurations) },
                onIncrement: { viewModel.updateRounds(by: 1, configurations: configurations) }
            )
        }
    }
}




