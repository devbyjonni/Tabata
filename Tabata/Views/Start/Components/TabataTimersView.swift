//
//  TabataTimersView.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI
import SwiftData

struct TabataTimersView: View {
    var body: some View {
        VStack(spacing: 16) {
            TabataTimerView(phase: .warmUp, icon: Icons.warmUp.rawValue, color: Theme.warmup)
            TabataTimerView(phase: .work, icon: Icons.work.rawValue, color: Theme.work)
            TabataTimerView(phase: .rest, icon: Icons.rest.rawValue, color: Theme.rest)
            TabataTimerView(phase: .coolDown, icon: Icons.cooldown.rawValue, color: Theme.cooldown)
        }
        .padding(.top, 10)
    }
}

internal struct TabataTimerView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var configurations: [TabataConfiguration]
    
    // We keep viewModel local as logic handler
    private let viewModel: StartViewModel = StartViewModel()
    
    let phase: WorkoutPhase
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            // Decrement
            Button(action: {
                HapticManager.shared.play(.light)
                viewModel.adjustTime(for: phase, by: -10, configurations: configurations) // Logic adapted to +/- 5 or 10 based on phase? dobata does different steps. keeping existing strategy or adopting dobata's? StartViewModel likely has generic. Let's stick to existing +/-10 or update viewModel later. StartViewModel 'adjustTime' handles logic.
            }) {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: Icons.minus.rawValue) // dobata uses "minus", Tabata uses Icons.minus
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.white)
                    )
            }
            
            Spacer()
            
            VStack(spacing: 2) {
                Text(time(for: phase))
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(.white)
                
                HStack(spacing: 4) {
                    Text(phase.rawValue.uppercased())
                        .font(.system(size: 10, weight: .black, design: .rounded))
                        .textCase(.uppercase)
                        .tracking(2)
                        .opacity(0.8)
                        .foregroundStyle(.white)
                    
                    Image(systemName: icon)
                        .font(.system(size: 12))
                        .foregroundStyle(.white.opacity(0.8))
                }
            }
            
            Spacer()
            
            // Increment
            Button(action: {
                HapticManager.shared.play(.light)
                viewModel.adjustTime(for: phase, by: 10, configurations: configurations)
            }) {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: Icons.plus.rawValue)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.white)
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: color.opacity(0.3), radius: 10, x: 0, y: 5)
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
