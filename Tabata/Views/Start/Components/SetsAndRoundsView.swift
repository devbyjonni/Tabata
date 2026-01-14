//
//  SetsAndRoundsView.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI
import SwiftData

/// Controls for setting the number of Sets and Rounds.
/// Also includes the global Sound Toggle control.
struct SetsAndRoundsView: View {
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
                isDarkMode: settings.first?.isDarkMode ?? true,
                onDecrement: { viewModel.updateSets(by: -1, configurations: configurations) },
                onIncrement: { viewModel.updateSets(by: 1, configurations: configurations) }
            )
            
            // Speaker
            ControlButton(
                icon: (settings.first?.isSoundEnabled ?? true) ? Icons.speaker.rawValue : Icons.speakerSlash.rawValue,
                backgroundColor: settings.first?.isDarkMode ?? true ? Color.slate800 : Color.slate200.opacity(0.5),
                foregroundColor: settings.first?.isDarkMode ?? true ? Color.white.opacity(0.5) : Color.slate900.opacity(0.5),
                size: 44,
                iconSize: 16
            ) {
                if let currentSettings = settings.first {
                    currentSettings.isSoundEnabled.toggle()
                }
            }
            .offset(y: 40)
            
            // Rounds
            CounterControl(
                label: "ROUNDS",
                value: "\(configurations.first?.rounds ?? 0)",
                isDarkMode: settings.first?.isDarkMode ?? true,
                onDecrement: { viewModel.updateRounds(by: -1, configurations: configurations) },
                onIncrement: { viewModel.updateRounds(by: 1, configurations: configurations) }
            )
        }
    }
}



#Preview {
    SetsAndRoundsView()
        .modelContainer(for: TabataConfiguration.self, inMemory: true)
}
