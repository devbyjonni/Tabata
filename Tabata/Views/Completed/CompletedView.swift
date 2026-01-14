//
//  CompletedView.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI
import SwiftData

/// Displayed when a workout is finished.
/// Shows a summary and allows the user to return to the start screen.
struct CompletedView: View {
    var action: () -> Void = {}
    @Query private var settings: [TabataSettings]
    
    var body: some View {
        ZStack {
            (settings.first?.isDarkMode ?? true ? Color.slate900 : Theme.background)
                .ignoresSafeArea()
            
            VStack(spacing: 2) {
                NavbarView(
                    title: "Completed",
                    leftIcon: Icons.xmark.rawValue,
                    rightIcon: Icons.share.rawValue,
                    leftAction: { action() },
                    rightAction: { print("Share tapped") }
                )
                Spacer()
                Text("WORKOUT COMPLETED!")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                Spacer()
                Button(action: {
                    HapticManager.shared.play(.medium)
                    action()
                }) {
                    Text("DONE")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding() // Add padding for the button
        }
    }
}

#Preview {
    CompletedView()
}
