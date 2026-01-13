//
//  NavbarView.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI
import SwiftData

struct NavbarView: View {
    let title: String
    let leftIcon: String
    let rightIcon: String
    var leftAction: () -> Void = {}
    var rightAction: () -> Void = {}
    
    @Query private var settings: [TabataSettings]
    
    var body: some View {
        HStack {
            NavbarButton(icon: leftIcon, isDarkMode: settings.first?.isDarkMode ?? true, action: leftAction)
            Spacer()
            Text(title.uppercased())
                .font(.system(size: 20, weight: .black, design: .rounded))
                .tracking(2)
                .foregroundStyle(settings.first?.isDarkMode ?? true ? .white : Color.primaryText)
            Spacer()
            NavbarButton(icon: rightIcon, isDarkMode: settings.first?.isDarkMode ?? true, action: rightAction)
        }
        .padding(.horizontal)
        .padding(.top, 20)
    }
}

internal struct NavbarButton: View {
    let icon: String
    var isDarkMode: Bool
    var action: () -> Void = {}
    
    var body: some View {
        if icon.isEmpty {
            Color.clear
                .frame(width: 44, height: 44)
        } else {
            ControlButton(
                icon: icon,
                backgroundColor: isDarkMode ? Color.slate800 : Color.slate200.opacity(0.5),
                foregroundColor: isDarkMode ? .white : Color.primaryText,
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
