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
            Button(action: {
                HapticManager.shared.play(.medium)
                if let currentSettings = settings.first {
                    currentSettings.isSoundEnabled.toggle()
                }
            }) {
                Image(systemName: (settings.first?.isSoundEnabled ?? true) ? Icons.speaker.rawValue : Icons.speakerSlash.rawValue)
                    .font(.system(size: 16))
                    .foregroundStyle(settings.first?.isDarkMode ?? true ? Color.white.opacity(0.5) : Color.slate900.opacity(0.5))
                    .frame(width: 44, height: 44)
                    .background(settings.first?.isDarkMode ?? true ? Color.slate800 : Color.slate200.opacity(0.5))
                    .clipShape(Circle())
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
                RoundButton(icon: "minus", isDarkMode: isDarkMode, action: onDecrement)
                
                Text(value)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(isDarkMode ? .white : Color.slate900)
                    .frame(minWidth: 60)
                
                RoundButton(icon: "plus", isDarkMode: isDarkMode, action: onIncrement)
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
        Button(action: {
            HapticManager.shared.play(.light)
            action()
        }) {
            Circle()
                .stroke(isDarkMode ? Color.slate600 : Color.slate300, lineWidth: 2)
                .background(Circle().fill(Color.clear))
                .frame(width: 32, height: 32)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(isDarkMode ? .white : Color.slate900)
                )
        }
    }
}

#Preview {
    SetsAndRoundsView()
        .modelContainer(for: TabataConfiguration.self, inMemory: true)
}
