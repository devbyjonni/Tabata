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
    @Environment(\.dismiss) private var dismiss
    var workout: CompletedWorkout?
    var leftIcon: String = Icons.xmark.rawValue
    var title: String? = nil
    var showConfetti: Bool = true
    var action: (() -> Void)? = nil
    @Query(sort: \CompletedWorkout.date, order: .reverse) private var history: [CompletedWorkout]
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                NavbarView(
                    title: title ?? "Completed",
                    leftContent: {
                        NavbarButton(icon: leftIcon) {
                            if let action = action {
                                action()
                            } else {
                                dismiss()
                            }
                        }
                    },
                    rightContent: {
                        ShareLink(item: shareText) {
                            // Replicating NavbarButton styling
                            ZStack {
                                Circle()
                                    .fill(Color.slate800)
                                    .frame(width: 44, height: 44)
                                Image(systemName: Icons.share.rawValue)
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                )
                
                ScrollView {
                    VStack(spacing: 32) {
                        VStack(spacing: 24) {
                            ZStack {
                                // Glow
                                Circle()
                                    .fill(Color.yellow.opacity(0.15))
                                    .frame(width: 140, height: 140)
                                    .blur(radius: 30)
                                
                                // Trophy Ring
                                Circle()
                                    .stroke(Color.yellow, lineWidth: 3)
                                    .frame(width: 100, height: 100)
                                
                                // Trophy Icon
                                Image(systemName: Icons.trophy.rawValue)
                                    .font(.system(size: 44))
                                    .foregroundStyle(.yellow)
                            }
                            VStack(spacing: 8) {
                                Text("Congratulations!")
                                    .font(.system(size: 32, weight: .black, design: .rounded))
                                    .foregroundStyle(.white)
                                
                                Text("You crushed your session.")
                                    .font(.system(size: 17, weight: .medium, design: .rounded))
                                    .foregroundStyle(Color.slate400)
                            }
                        }
                        .padding(.top, 0)
                        
                        if let workout = workout ?? history.first {
                            WorkoutStatisticsGrid(
                                duration: workout.duration,
                                warmUp: workout.totalWarmUp,
                                work: workout.totalWork,
                                rest: workout.totalRest,
                                coolDown: workout.totalCoolDown,
                                reps: workout.reps,
                                rounds: workout.rounds,
                                workoutCount: 1
                            )
                        } else {
                            Text("No Statistics Available\n(Workout: \(workout == nil ? "nil" : "ok"), History: \(history.count))")
                                .multilineTextAlignment(.center)
                                .foregroundStyle(Color.slate500)
                                .padding()
                        }
                    }
                    .padding()
                }
            }
        }
        .background(Color.slate900)
        .navigationBarBackButtonHidden(true)
        .overlay {
            if showConfetti {
                ConfettiView()
            }
        }
    }
    
    // MARK: - Share Logic
    
    private var shareText: String {
        guard let w = workout ?? history.first else {
            return "Check out Tabata Pro! A great app for HIIT workouts."
        }
        
        return "I just crushed a Tabata workout! 🔥 \(w.duration.formatTime()) • \(w.rounds) Rounds • \(w.reps) Reps #TabataPro"
    }
}
