//
//  NavbarView.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI

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
            Text(title)
                .font(.system(size: 34, weight: .bold, design: .rounded))
            Spacer()
            NavbarButton(icon: rightIcon, action: rightAction)
        }
    }
}

internal struct NavbarButton: View {
    let icon: String
    var action: () -> Void = {}
    
    var body: some View {
        if icon.isEmpty {
            Spacer()
                .frame(width: 50, height: 50)
        } else {
            ControlButton(
                icon: icon,
                backgroundColor: .clear,
                foregroundColor: .primary,
                size: 50,
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
