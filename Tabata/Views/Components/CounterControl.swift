//
//  CounterControl.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI

/// A reusable component for increment/decrement counters with a label.
/// Uses `ControlButton` for the +/- actions.
struct CounterControl: View {
    let label: String
    let value: String
    var isDarkMode: Bool
    var onDecrement: () -> Void = {}
    var onIncrement: () -> Void = {}
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 16) {
                // Decrement Button
                ControlButton(
                    icon: Icons.minus.rawValue,
                    backgroundColor: .clear,
                    foregroundColor: isDarkMode ? .white : Color.slate900,
                    size: 32,
                    iconSize: 14,
                    borderColor: isDarkMode ? Color.slate600 : Color.slate300,
                    borderWidth: 2
                ) {
                    onDecrement()
                }
                
                // Value Display
                Text(value)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(isDarkMode ? .white : Color.slate900)
                    .frame(minWidth: 60)
                
                // Increment Button
                ControlButton(
                    icon: Icons.plus.rawValue,
                    backgroundColor: .clear,
                    foregroundColor: isDarkMode ? .white : Color.slate900,
                    size: 32,
                    iconSize: 14,
                    borderColor: isDarkMode ? Color.slate600 : Color.slate300,
                    borderWidth: 2
                ) {
                    onIncrement()
                }
            }
            
            // Label
            Text(label)
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .tracking(2)
                .foregroundStyle(isDarkMode ? Color.slate400 : Color.slate900.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ZStack {
        Color.slate900.ignoresSafeArea()
        CounterControl(label: "SETS", value: "8", isDarkMode: true)
    }
}
