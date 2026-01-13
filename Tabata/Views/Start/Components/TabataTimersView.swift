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
        VStack(spacing: 2) {
            TabataTimerView(phase: WorkoutPhase.warmUp, icon: Icons.warmUp.rawValue)
            TabataTimerView(phase: WorkoutPhase.work, icon: Icons.work.rawValue)
            TabataTimerView(phase: WorkoutPhase.rest, icon: Icons.rest.rawValue)
            TabataTimerView(phase: WorkoutPhase.coolDown, icon: Icons.cooldown.rawValue)
        }
    }
}

internal struct TabataTimerView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var configurations: [TabataConfiguration]
    
    private let viewModel: StartViewModel = StartViewModel()
    
    let phase: WorkoutPhase
    
    let icon: String
    
    var body: some View {
        HStack {
            ControlButton(icon: Icons.minus.rawValue, backgroundColor: .gray.opacity(0.2), foregroundColor: .primary, size: 50, iconSize: 20) {
                viewModel.adjustTime(for: phase, by: -10, configurations: configurations)
            }
            Spacer()
            VStack {
                Text(time(for: phase))
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                HStack {
                    Text(phase.rawValue.uppercased())
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            ControlButton(icon: Icons.plus.rawValue, backgroundColor: .gray.opacity(0.2), foregroundColor: .primary, size: 50, iconSize: 20) {
                viewModel.adjustTime(for: phase, by: 10, configurations: configurations)
            }
        }
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
