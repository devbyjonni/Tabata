//
//  IntervalCard.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI

/// A card displaying a specific workout interval (Warm Up, Work, Rest, etc.)
/// with increment/decrement controls.
struct IntervalCard: View {
    let title: String
    let time: String
    let color: Color
    let icon: String
    var onDecrement: () -> Void = {}
    var onIncrement: () -> Void = {}
    
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
                onDecrement()
            }
            
            Spacer()
            
            VStack(spacing: 2) {
                Text(time)
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(.white)
                
                HStack(spacing: 4) {
                    Text(title)
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
                onIncrement()
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: color.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}


