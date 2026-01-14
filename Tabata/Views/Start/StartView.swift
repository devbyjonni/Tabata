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
            Color.slate900.ignoresSafeArea()
            
            VStack(spacing: 0) {
                NavbarView(
                    title: "TABATA",
                    leftIcon: Icons.stats.rawValue,
                    rightIcon: Icons.settings.rawValue,
                    leftAction: { showStats = true },
                    rightAction: { showSettings = true }
                )
                
                ScrollView {
                    VStack(spacing: 32) {
                        TimerTextView()
                            .padding(.top, 20)
                        
                        SetsAndRoundsView()
                        
                        TabataTimersView()
                            .padding(.top, 10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 120)
                }
            }
        }
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
        .preferredColorScheme(.dark)
        .onAppear {
            if self.configurations.isEmpty {
                let newSettings = TabataConfiguration()
                modelContext.insert(newSettings)
            }
            if self.settings.isEmpty {
                let newSettings = TabataSettings()
                modelContext.insert(newSettings)
            }
        }
    }
}

// MARK: Preview
#Preview {
    StartView()
        .modelContainer(for: TabataConfiguration.self, inMemory: true)
}
