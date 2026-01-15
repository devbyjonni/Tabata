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
    var action: (() -> Void)? = nil
    @Query(sort: \CompletedWorkout.date, order: .reverse) private var history: [CompletedWorkout]
    
    var body: some View {
        ZStack {
            Color.slate900.ignoresSafeArea()
            
            VStack(spacing: 0) {
                NavbarView(
                    title: "Completed",
                    leftIcon: leftIcon,
                    rightIcon: Icons.share.rawValue,
                    leftAction: {
                        if let action = action {
                            action()
                        } else {
                            dismiss()
                        }
                    },
                    rightAction: {
                        // Share logic placeholder
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
                        
                        Color.clear.frame(height: 20)
                    }
                    .padding()
                }
            }
        }

        .navigationBarBackButtonHidden(true)
        .overlay {
            ConfettiView()
        }
    }
}


