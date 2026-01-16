//
//  StartView.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-12.
//

import SwiftUI
import SwiftData

// MARK: Start View
/// The main entry point of the app.
/// Configures the workout (Sets, Rounds, Intervals) and navigates to other screens.
struct StartView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var configurations: [TabataConfiguration]
    @Query private var settings: [TabataSettings]
    
    @State private var showWorkout = false
    @State private var showCompletion = false
    @State private var showStats = false
    @State private var showSettings = false

    @State private var workoutCompleted = false
    @State private var lastCompletedWorkout: CompletedWorkout?
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                NavbarView(
                    title: "TABATA PRO",
                    leftContent: {
                        NavbarButton(icon: Icons.stats.rawValue, action: { showStats = true })
                    },
                    rightContent: {
                        NavbarButton(icon: Icons.settings.rawValue, action: { showSettings = true })
                    }
                )
                
                ScrollView {
                    VStack(spacing: 32) {
                        TotalDurationView()
                            .padding(.top, 20)
                        
                        SetsRoundsSelector()
                          
                        PhaseSettingsList()
                            .padding(.top, 10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 120)
                }
            }
        }
        .background(Color.slate900)
        .overlay(alignment: .bottom) {
            VStack {
                Spacer()
                ControlButton(
                    icon: Icons.play.rawValue,
                    backgroundColor: Theme.primary,
                    foregroundColor: .white,
                    size: 80,
                    iconSize: 40,
                    shadowColor: Theme.primary.opacity(0.4),
                    shadowRadius: 10,
                    shadowX: 0,
                    shadowY: 10
                ) {
                    workoutCompleted = false
                    showWorkout = true
                    HapticManager.shared.notification(.success)
                }
                .padding(.bottom, 10)
                .offset(x: 3) // Fine-tune play icon centering if needed, though ControlButton usually centers. Play.fill often needs offset.
            }
        }
        .fullScreenCover(isPresented: $showWorkout, onDismiss: {
            if workoutCompleted {
                // Slight delay to allow dismissal animation to finish
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    showCompletion = true
                }
            }
        }) {
            WorkoutView(completed: $workoutCompleted, savedWorkout: $lastCompletedWorkout)
        }
        .fullScreenCover(isPresented: $showCompletion) {
            CompletedView(workout: lastCompletedWorkout, action: {
                showCompletion = false
            })
        }
        .fullScreenCover(isPresented: $showStats) {
            StatsView()
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .onAppear {
            if self.configurations.isEmpty {
                let newSettings = TabataConfiguration()
                modelContext.insert(newSettings)
            }
            if self.settings.isEmpty {
                let newSettings = TabataSettings()
                modelContext.insert(newSettings)
            }
            
            // Sync settings to Managers
            if let currentSettings = settings.first {
                 SoundManager.shared.isSoundEnabled = currentSettings.isSoundEnabled
                 SoundManager.shared.isVoiceGuideEnabled = currentSettings.isVoiceGuideEnabled
                 SoundManager.shared.volume = currentSettings.volume
                 SoundManager.shared.countdownDuration = currentSettings.countdownDuration
                 HapticManager.shared.isHapticsEnabled = currentSettings.isHapticsEnabled
            }
        }
    }
}

// MARK: Preview
#Preview {
    StartView()
        .modelContainer(for: TabataConfiguration.self, inMemory: true)
}
