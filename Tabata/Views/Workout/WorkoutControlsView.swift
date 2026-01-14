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
                backgroundColor: .red.opacity(0.8),
                foregroundColor: .white,
                size: 60,
                iconSize: 24
            ) {
                viewModel.stop()
                dismissAction()
            }
            
            // Play/Pause
            ControlButton(
                icon: viewModel.isActive ? Icons.pause.rawValue : Icons.play.rawValue,
                backgroundColor: viewModel.isActive ? .orange : .green,
                foregroundColor: .white,
                size: 100,
                iconSize: 50
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
                backgroundColor: .blue.opacity(0.8),
                foregroundColor: .white,
                size: 60,
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
