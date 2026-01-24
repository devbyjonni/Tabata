//
//  IntervalCard.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI
import SwiftData

/// A card displaying a specific workout phase (Warm Up, Work, Rest, etc.).
///
/// It allows the user to adjust the duration of the phase directly via SwiftData.
/// Does not require binding or parent callbacks.
struct IntervalCard: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var configurations: [TabataConfiguration]
    
    let phase: WorkoutPhase
    let color: Color
    let icon: String
    
    /// The increment/decrement step in seconds.
    var step: Double = 10
    
    // MARK: - Computed Properties
    
    private var value: Double {
        guard let config = configurations.first else { return 0 }
        switch phase {
        case .warmUp: return config.warmUpTime
        case .work: return config.workTime
        case .rest: return config.restTime
        case .restBetweenRounds: return config.restBetweenRounds
        case .coolDown: return config.coolDownTime
        case .idle: return 0
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            // Decrement
            ControlButton(
                icon: Icons.minus.rawValue,
                backgroundColor: Color.white.opacity(0.2),
                foregroundColor: .white,
                size: 40,
                iconSize: 18
            ) {
                updateValue(by: -step)
            }
            
            Spacer()
            
            VStack(spacing: 2) {
                Text(value.formatTime())
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(.white)
                
                HStack(spacing: 4) {
                    Text(phase.rawValue)
                        .font(.system(size: 15, weight: .black, design: .rounded))
                        .textCase(.uppercase)
                        .tracking(2)
                        .opacity(0.8)
                        .foregroundStyle(.white)
                }
            }
            
            Spacer()
            
            // Increment
            ControlButton(
                icon: Icons.plus.rawValue,
                backgroundColor: Color.white.opacity(0.2),
                foregroundColor: .white,
                size: 40,
                iconSize: 18
            ) {
                updateValue(by: step)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: color.opacity(0.3), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Action Handlers
    
    private func updateValue(by amount: Double) {
        guard let config = configurations.first else { return }
        
        // Range: 0 to 10 minutes (600 seconds)
        let range: ClosedRange<Double> = 0...600
        
        let newValue = value + amount
        if !range.contains(newValue) { return }
        
        switch phase {
        case .warmUp: config.warmUpTime = newValue
        case .work: config.workTime = newValue
        case .rest: config.restTime = newValue
        case .restBetweenRounds: config.restBetweenRounds = newValue
        case .coolDown: config.coolDownTime = newValue
        case .idle: break // Idle phase doesn't have a time to update
        }
        
        HapticManager.shared.play(.light)
    }
}
