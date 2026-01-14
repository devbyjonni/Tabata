//
//  WorkoutControlsView.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI

/// Playback controls for the workout (Pause, Resume, Stop, Skip).
struct WorkoutControlsView: View {
    @Bindable var viewModel: WorkoutViewModel
    var dismissAction: () -> Void
    
    var body: some View {
        HStack(spacing: 40) {
            // Stop
            ControlButton(
                icon: Icons.stop.rawValue,
                backgroundColor: Color.white.opacity(0.3),
                foregroundColor: .white,
                size: 64,
                iconSize: 24
            ) {
                viewModel.stop()
                dismissAction()
            }
            
            // Pause / Resume
            ControlButton(
                icon: viewModel.isActive ? Icons.pause.rawValue : Icons.play.rawValue,
                backgroundColor: Color.white.opacity(0.3),
                foregroundColor: .white,
                size: 100,
                iconSize: 40,
                borderColor: .white.opacity(0.3),
                borderWidth: 4
            ) {
                if viewModel.isActive {
                    viewModel.pause()
                } else {
                    viewModel.play()
                }
            }
            
            // Skip
            ControlButton(
                icon: Icons.skip.rawValue,
                backgroundColor: Color.white.opacity(0.3),
                foregroundColor: .white,
                size: 64,
                iconSize: 24
            ) {
                viewModel.skip()
            }
        }
        .padding(.vertical)
    }
}

#Preview {
    WorkoutControlsView(viewModel: WorkoutViewModel(), dismissAction: {})
}
