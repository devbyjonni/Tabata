//
//  WorkoutStatisticsGrid.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-14.
//

import SwiftUI

/// Displays a grid of workout statistics, including total duration, workouts, breakdown by phase, rounds, and reps.
/// Used in `StatsView` and `CompletedView`.
struct WorkoutStatisticsGrid: View {
    let duration: TimeInterval
    let warmUp: TimeInterval
    let work: TimeInterval
    let rest: TimeInterval
    let coolDown: TimeInterval
    let reps: Int
    let rounds: Int
    let workoutCount: Int
    
    var body: some View {
        VStack(spacing: 12) {
            
            // Total Workouts Card
            StatsSummaryCard(
                title: "WORKOUTS",
                value: "\(workoutCount)",
                icon: Icons.trophy.rawValue,
                iconColor: Color.yellow.opacity(0.8)
            )
            
            // Total Duration Card
            StatsSummaryCard(
                title: "DURATION",
                value: duration.formatTime(),
                icon: Icons.clock.rawValue,
                iconColor: Color.white.opacity(0.8)
            )
            
            // Bottom Row: Rounds & Reps
            HStack(spacing: 12) {
                // Rounds
                SmallStatCard(
                    title: "ROUNDS",
                    value: "\(rounds)",
                    icon: Icons.trophy.rawValue,
                    iconColor: .yellow
                )
                
                // Reps
                SmallStatCard(
                    title: "REPS",
                    value: "\(reps)",
                    icon: Icons.repeatIcon.rawValue,
                    iconColor: .blue
                )
            }
            
            // Phase Breakdown Grid
            HStack(spacing: 12) {
                // Left Column
                VStack(spacing: 12) {
                    StatCard(
                        title: "WARMUP",
                        value: warmUp.formatTime(),
                        color: Theme.warmup,
                        icon: Icons.warmUp.rawValue
                    )
                    StatCard(
                        title: "REST",
                        value: rest.formatTime(),
                        color: Theme.rest,
                        icon: Icons.rest.rawValue
                    )
                }
                
                // Right Column
                VStack(spacing: 12) {
                    StatCard(
                        title: "WORK",
                        value: work.formatTime(),
                        color: Theme.work,
                        icon: Icons.work.rawValue
                    )
                    StatCard(
                        title: "COOL DOWN",
                        value: coolDown.formatTime(),
                        color: Theme.cooldown,
                        icon: Icons.cooldown.rawValue
                    )
                }
            }
            
           
        }
    }
}

// Internal Stat Card Component (Big Colored Cards)
fileprivate struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                Text(title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.white.opacity(0.9))
            }
            .padding(.bottom, 24)
            
            Text(value)
                .font(.system(size: 28, weight: .black, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(.white)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: .clear, radius: 8, x: 0, y: 4)
    }
}

// Reusable Small Stat Card (Bottom Row)
fileprivate struct SmallStatCard: View {
    let title: String
    let value: String
    let icon: String
    let iconColor: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Color.slate400)
                Text(value)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
            }
            Spacer()
            
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.2))
                    .frame(width: 32, height: 32)
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(iconColor)
            }
        }
        .padding(24)
        .background(Color.slate800)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .shadow(color: .clear, radius: 10, x: 0, y: 4)
    }
}
