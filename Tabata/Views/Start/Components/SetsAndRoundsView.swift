//
//  SetsAndRoundsView.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI
import SwiftData

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
            .offset(y: 10)
            
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

// MARK: - Helpers
struct CounterControl: View {
    let label: String
    let value: String
    var isDarkMode: Bool
    var onDecrement: () -> Void = {}
    var onIncrement: () -> Void = {}
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 16) {
                RoundButton(icon: Icons.minus.rawValue, isDarkMode: isDarkMode, action: onDecrement)
                
                Text(value)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(isDarkMode ? .white : Color.slate900)
                    .frame(minWidth: 60)
                
                RoundButton(icon: Icons.plus.rawValue, isDarkMode: isDarkMode, action: onIncrement)
            }
            
            Text(label)
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .tracking(2)
                .foregroundStyle(isDarkMode ? Color.slate400 : Color.slate900.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
    }
}

struct RoundButton: View {
    let icon: String
    var isDarkMode: Bool = false
    var action: () -> Void = {}
    
    var body: some View {
        ControlButton(
            icon: icon,
            backgroundColor: .clear,
            foregroundColor: isDarkMode ? .white : Color.slate900,
            size: 32,
            iconSize: 14,
            borderColor: isDarkMode ? Color.slate600 : Color.slate300,
            borderWidth: 2
        ) {
            action()
        }
    }
}

#Preview {
    SetsAndRoundsView()
        .modelContainer(for: TabataConfiguration.self, inMemory: true)
}
