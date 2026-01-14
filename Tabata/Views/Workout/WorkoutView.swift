//
//  WorkoutView.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI
import SwiftData
import Combine

/// The active workout screen.
/// Manages the workout timer, displays the current phase, and handles user controls (Pause, Resume, Stop).
struct WorkoutView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var configurations: [TabataConfiguration]
    @Query private var settings: [TabataSettings]
    @Binding var completed: Bool
    
    @State private var viewModel = WorkoutViewModel()
    @State private var timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            (settings.first?.isDarkMode ?? true ? Color.slate900 : Theme.background)
                .ignoresSafeArea()
            
            VStack(spacing: 2) {
                NavbarView(
                    title: viewModel.isFinished ? "Done" : "Workout",
                    leftIcon: Icons.xmark.rawValue,
                    rightIcon: (settings.first?.isSoundEnabled ?? true) ? Icons.speaker.rawValue : Icons.speakerSlash.rawValue,
                    leftAction: {
                        viewModel.stop()
                        dismiss()
                    },
                    rightAction: {
                        settings.first?.isSoundEnabled.toggle()
                        HapticManager.shared.play(.light)
                    }
                )
                
                VStack(spacing: 2) {
                    
                    Spacer()
                    
                    PhaseTitleView(phase: viewModel.phase)
                    
                    Spacer()
                    
                    WorkoutTimerView(viewModel: viewModel)
                    
                    Spacer()
                    
                    WorkoutStatsView(viewModel: viewModel)
                    
                    Spacer()
                    
                    WorkoutControlsView(viewModel: viewModel, dismissAction: {
                        dismiss()
                    })
                    
                    Spacer()
                }
                .padding()
            }
        }
        .onAppear {
            if let config = configurations.first, let currentSettings = self.settings.first {
                // Initialize UI immediately
                viewModel.setup(config: config, settings: currentSettings)
                
                // Delay start to allow view transition to complete
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) {
                    viewModel.play()
                }
            }
        }
        .onReceive(timer) { _ in
            viewModel.tick()
        }
        .onChange(of: viewModel.isFinished) { _, newValue in
            if newValue {
                completed = true
                dismiss() // Determine done, dismiss view
            }
        }
    }
}

#Preview {
    WorkoutView(completed: .constant(false))
        .modelContainer(for: TabataConfiguration.self, inMemory: true)
}
