//  SetsRoundsSelector.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI
import SwiftData

/// A container view for configuring Sets and Rounds.
///
/// Composes `CounterControl` components for data modification and
/// also hosts the global Sound Toggle control.
struct SetsRoundsSelector: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var settings: [TabataSettings]
    
    var body: some View {
        HStack {
            // Sets
            CounterControl(type: .sets)
            
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
            CounterControl(type: .rounds)
        }
    }
}
