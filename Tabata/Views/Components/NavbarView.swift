//
//  NavbarView.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI
import SwiftData

/// A flexible navigation bar component that accepts generic views for left and right utility areas.
///
/// Uses `@ViewBuilder` to allow any SwiftUI view (buttons, text, empty views) to be passed
/// seamlessly, providing a standardized title layout with customizable actions.
struct NavbarView<LeftContent: View, RightContent: View>: View {
    let title: String
    
    /// The content to place on the left side (e.g., Back button, Cancel).
    @ViewBuilder let leftContent: () -> LeftContent
    
    /// The content to place on the right side (e.g., Save, Edit, Share).
    @ViewBuilder let rightContent: () -> RightContent
    
    var body: some View {
        ZStack {
            // Side Buttons
            HStack {
                leftContent()
                Spacer()
                rightContent()
            }
            
            // Centered Title
            Text(title.uppercased())
                .font(.system(size: 20, weight: .black, design: .rounded))
                .tracking(2)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .padding(.horizontal, 60) // Prevent overlap with buttons
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


