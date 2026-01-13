//
//  ControlButton.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI

struct ControlButton: View {
    let icon: String
    let backgroundColor: Color
    let foregroundColor: Color
    var size: CGFloat = 80
    var iconSize: CGFloat = 30
    var borderColor: Color = .clear
    var borderWidth: CGFloat = 0
    var shadowColor: Color = .clear
    var shadowRadius: CGFloat = 0
    var shadowX: CGFloat = 0
    var shadowY: CGFloat = 0
    var action: () -> Void = {}
    
    var body: some View {
        Button(action: {
            HapticManager.shared.play(.medium)
            action()
        }) {
            ZStack {
                Circle()
                    .fill(backgroundColor)
                    .overlay(
                        Circle()
                            .stroke(borderColor, lineWidth: borderWidth)
                    )
                    .frame(width: size, height: size)
                    .shadow(color: shadowColor, radius: shadowRadius, x: shadowX, y: shadowY)
                Image(systemName: icon)
                    .font(.system(size: iconSize, weight: .bold, design: .rounded))
                    .foregroundColor(foregroundColor)
            }
        }
    }
}

#Preview {
    ControlButton(
        icon: Icons.play.rawValue,
        backgroundColor: .green,
        foregroundColor: .white
    )
}
