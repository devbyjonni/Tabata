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
        ZStack {
            (settings.first?.isDarkMode ?? true ? Color.slate900 : Theme.background)
                .ignoresSafeArea()
            
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
                Button(action: {
                    workoutCompleted = false
                    showWorkout = true
                    HapticManager.shared.notification(.success)
                }) {
                    ZStack {
                        Circle()
                            .fill(Theme.primary)
                            .frame(width: 80, height: 80)
                            .shadow(color: Theme.primary.opacity(0.4), radius: 10, x: 0, y: 10)
                        
                        Image(systemName: Icons.play.rawValue)
                            .font(.system(size: 40))
                            .foregroundStyle(.white)
                            .offset(x: 3)
                    }
                }
                .padding(.bottom, 10)
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
        .preferredColorScheme(settings.first?.isDarkMode ?? true ? .dark : .light)
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
