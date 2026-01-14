//
//  NavbarView.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI
import SwiftData

/// Navigation bar component with title and optional left/right action buttons.
/// Adapts its style based on the current context and theme (Dark Mode support).
struct NavbarView: View {
    let title: String
    let leftIcon: String
    let rightIcon: String
    var leftAction: () -> Void = {}
    var rightAction: () -> Void = {}
    
    var body: some View {
        HStack {
            NavbarButton(icon: leftIcon, action: leftAction)
            Spacer()
            Text(title.uppercased())
                .font(.system(size: 20, weight: .black, design: .rounded))
                .tracking(2)
                .foregroundStyle(.white)
            Spacer()
            NavbarButton(icon: rightIcon, action: rightAction)
        }
        .padding(.horizontal)
        .padding(.top, 20)
    }
}

internal struct NavbarButton: View {
    let icon: String
    var action: () -> Void = {}
    
    var body: some View {
        if icon.isEmpty {
            Color.clear
                .frame(width: 44, height: 44)
        } else {
            ControlButton(
                icon: icon,
                backgroundColor: Color.slate800,
                foregroundColor: .white,
                size: 44,
                iconSize: 20
            ) {
                action()
            }
        }
    }
}

#Preview {
    NavbarView(
        title: "Navbar",
        leftIcon: Icons.stats.rawValue,
        rightIcon: Icons.settings.rawValue
    )
}
