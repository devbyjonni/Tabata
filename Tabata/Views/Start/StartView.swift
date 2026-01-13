//
//  StartView.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-12.
//

import SwiftUI
import SwiftData

// MARK: Start View
struct StartView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var configurations: [TabataConfiguration]
    @Query private var settings: [TabataSettings]
    
    @State private var showWorkout = false
    @State private var showCompletion = false
    @State private var showStats = false
    @State private var showSettings = false
    @State private var workoutCompleted = false
    
    var body: some View {
        VStack(spacing: 2) {
            NavbarView(
                title: "Start",
                leftIcon: Icons.stats.rawValue,
                rightIcon: Icons.settings.rawValue,
                leftAction: { showStats = true },
                rightAction: { showSettings = true }
            )
            ScrollView {
                VStack(spacing: 2) {
                    TimerTextView()
                    SetsAndRoundsView()
                    ControlButton(
                        icon: (self.settings.first?.isSoundEnabled ?? true) ? Icons.speaker.rawValue : Icons.speakerSlash.rawValue,
                        backgroundColor: .clear,
                        foregroundColor: (self.settings.first?.isSoundEnabled ?? true) ? .primary : .secondary,
                        size: 50,
                        iconSize: 20
                    ) {
                        self.settings.first?.isSoundEnabled.toggle()
                        HapticManager.shared.play(.light)
                    }
                    TabataTimersView()
                    Spacer()
                }
                .padding(.horizontal)
                
            }
        }
        .overlay(alignment: .bottom) {
            ControlButton(
                icon: Icons.play.rawValue,
                backgroundColor: .green,
                foregroundColor: .white,
                size: 100,
                iconSize: 50
            ) {
                workoutCompleted = false
                showWorkout = true
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
            WorkoutView(completed: $workoutCompleted)
        }
        .fullScreenCover(isPresented: $showCompletion) {
            CompletedView(action: {
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
        }
    }
}

// MARK: Preview
#Preview {
    StartView()
        .modelContainer(for: TabataConfiguration.self, inMemory: true)
}
