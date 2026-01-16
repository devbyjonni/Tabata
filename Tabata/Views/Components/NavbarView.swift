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
struct NavbarView<LeftContent: View, RightContent: View>: View {
    let title: String
    @ViewBuilder let leftContent: () -> LeftContent
    @ViewBuilder let rightContent: () -> RightContent
    
    // Convenience init for legacy usage (migrating this helps, but we can also just update call sites)
    // For now, let's making it purely generic to be clean.
    
    var body: some View {
        HStack {
            leftContent()
            Spacer()
            Text(title.uppercased())
                .font(.system(size: 20, weight: .black, design: .rounded))
                .tracking(2)
                .foregroundStyle(.white)
            Spacer()
            rightContent()
        }
        .padding(.horizontal)
        .padding(.top, 20)
    }
}

// Helper for standard buttons to make call sites cleaner
struct NavbarButton: View {
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


