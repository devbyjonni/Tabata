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
    @Binding var savedWorkout: CompletedWorkout?
    
    @State private var viewModel = WorkoutViewModel()
    @State private var timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Dynamic Background based on phase
            backgroundColor(for: viewModel.phase)
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0), value: viewModel.phase)
            
            VStack(spacing: 2) {
                // Header
                HStack {
                    // Close Button
                    ControlButton(
                        icon: Icons.xmark.rawValue,
                        backgroundColor: Color.white.opacity(0.3),
                        foregroundColor: .white,
                        size: 44,
                        iconSize: 18
                    ) {
                        viewModel.stop()
                        dismiss()
                    }
                    
                    Spacer()
                    
                    // Title
                    Text(viewModel.isFinished ? "DONE" : "WORKOUT")
                        .font(.system(size: 20, weight: .black, design: .rounded))
                        .tracking(2)
                        .foregroundStyle(.white)
                        //.textCase(.uppercase) // text is already uppercased in string literal for "WORKOUT", "DONE" is uppercase? "Done" in code. so .textCase(.uppercase) is good.
                        .textCase(.uppercase)
                    
                    Spacer()
                    
                    // Sound Toggle
                    ControlButton(
                        icon: (settings.first?.isSoundEnabled ?? true) ? Icons.speaker.rawValue : Icons.speakerSlash.rawValue,
                        backgroundColor: Color.white.opacity(0.3),
                        foregroundColor: .white,
                        size: 44,
                        iconSize: 16
                    ) {
                        if let currentSettings = settings.first {
                            currentSettings.isSoundEnabled.toggle()
                            SoundManager.shared.isSoundEnabled = currentSettings.isSoundEnabled
                            HapticManager.shared.play(.light)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
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
        .preferredColorScheme(.dark) // Force light text for status bar and alerts
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
                if let completedWorkout = viewModel.generateCompletedWorkout() {
                    modelContext.insert(completedWorkout)
                    try? modelContext.save() // Force save
                    savedWorkout = completedWorkout
                    completed = true
                    
                    // Slight delay to ensure binding propagates before dismissal
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        dismiss()
                    }
                } else {
                    dismiss()
                }
            }
        }
    }
    
    private func backgroundColor(for phase: WorkoutPhase) -> Color {
        switch phase {
        case .warmUp: return Theme.warmup
        case .work: return Theme.work
        case .rest: return Theme.rest
        case .coolDown: return Theme.cooldown
        case .idle: return Theme.background
        }
    }
        
}


