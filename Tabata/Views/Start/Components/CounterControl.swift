//
//  CounterControl.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI
import SwiftData

/// A reusable component for increment/decrement counters with a label.
///
/// It automatically queries the `TabataConfiguration` and updates either the
/// number of Sets or Rounds based on the provided `CounterType`.
struct CounterControl: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var configurations: [TabataConfiguration]
    
    /// The type of counter (Sets or Rounds).
    let type: CounterType
    
    // MARK: - Constants
    
    /// Constraints for the counter value (1 to 10).
    private let range = 1...10
    
    // MARK: - Computed Properties
    
    private var value: Int {
        guard let config = configurations.first else { return 0 }
        switch type {
        case .sets: return config.sets
        case .rounds: return config.rounds
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 12) {
                // Decrement Button
                ControlButton(
                    icon: Icons.minus.rawValue,
                    backgroundColor: .clear,
                    foregroundColor: .white,
                    size: 32,
                    iconSize: 14,
                    borderColor: Color.slate600,
                    borderWidth: 2
                ) {
                    updateValue(by: -1)
                }
                
                // Value Display
                Text("\(value)")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(.white)
                    .frame(minWidth: 60)
                
                // Increment Button
                ControlButton(
                    icon: Icons.plus.rawValue,
                    backgroundColor: .clear,
                    foregroundColor: .white,
                    size: 32,
                    iconSize: 14,
                    borderColor: Color.slate600,
                    borderWidth: 2
                ) {
                    updateValue(by: 1)
                }
            }
            
            // Label
            Text(type.rawValue)
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .tracking(2)
                .foregroundStyle(Color.slate400)
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Action Handlers
    
    /// Updates the configuration value within the defined range.
    private func updateValue(by amount: Int) {
        guard let config = configurations.first else { return }
        
        let newValue = value + amount
        if !range.contains(newValue) { return }
        
        switch type {
        case .sets: config.sets = newValue
        case .rounds: config.rounds = newValue
        }
        
        HapticManager.shared.play(.light)
    }
}


