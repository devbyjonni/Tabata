//
//  StatsListView.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI
import SwiftData

/// Displays a detailed list of past workouts.
/// Supports deletion and navigation to workout details.
struct StatsListView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(\.editMode) private var editMode
    
    // Sort logic handled by Query
    @Query(sort: \CompletedWorkout.date, order: .reverse) private var history: [CompletedWorkout]
    
    // Local state to manage edit mode if not using Environment driven EditButton
    @State private var isEditing: Bool = false
    
    var body: some View {
        ZStack {
            Color.slate900.ignoresSafeArea()
            
            if history.isEmpty {
                VStack {
                    // Header
                    NavbarView(
                        title: "History",
                        leftIcon: Icons.back.rawValue,
                        rightIcon: "",
                        leftAction: { dismiss() },
                        rightAction: {}
                    )
                    
                    if #available(iOS 17.0, *) {
                        ContentUnavailableView(
                            "No Workouts Yet",
                            systemImage: "figure.highintensity.intervaltraining",
                            description: Text("Complete your first Tabata to see it here.")
                        )
                        .foregroundStyle(Color.slate400)
                    } else {
                        // Fallback for older iOS (though we target recent)
                        VStack(spacing: 16) {
                            Spacer()
                            Image(systemName: "figure.highintensity.intervaltraining")
                                .font(.system(size: 60))
                                .foregroundStyle(Color.slate700)
                            Text("No workouts yet")
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                                .foregroundStyle(Color.slate500)
                            Spacer()
                        }
                    }
                    Spacer()
                }
            } else {
                VStack(spacing: 0) {
                    // Header with Edit Button Logic
                    NavbarView(
                        title: "History",
                        leftIcon: Icons.back.rawValue,
                        // Show checkmark if editing, pencil if not. Only if history exists.
                        rightIcon: isEditing ? "checkmark" : Icons.edit.rawValue,
                        leftAction: { dismiss() },
                        rightAction: {
                            withAnimation {
                                isEditing.toggle()
                            }
                        }
                    )
                    .padding(.bottom, 10)
                    
                    List {
                        ForEach(history) { workout in
                            // Use ZStack to support tap navigation while allowing Edit mode selection
                            ZStack {
                                NavigationLink(destination: CompletedView(workout: workout, leftIcon: Icons.back.rawValue)) {
                                    EmptyView()
                                }
                                .opacity(0) // Hide the chevron if we want custom look, or keep it.
                                // dobata hides the list row background
                                
                                HistoryRow(workout: workout)
                            }
                            .listRowBackground(Color.slate800)
                            .listRowSeparatorTint(Color.slate700)
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .environment(\.editMode, .constant(isEditing ? .active : .inactive))
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(history[index])
            }
        }
        // If empty after delete, exit edit mode
        if history.isEmpty {
            isEditing = false
        }
    }
}

fileprivate struct HistoryRow: View {
    let workout: CompletedWorkout
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(workout.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.headline)
                    .foregroundStyle(.white)
                
                HStack(spacing: 6) {
                    Label(workout.duration.formatTime(), systemImage: Icons.clock.rawValue)
                    Text("•")
                    Label("\(workout.reps) reps", systemImage: Icons.repeatIcon.rawValue)
                }
                .font(.caption)
                .foregroundStyle(Color.slate400)
            }
            Spacer()
            
            // Chevron is handled by NavigationLink explicitly or implicitly. 
            // If we want custom chevron:
             Image(systemName: "chevron.right")
                 .font(.caption)
                 .foregroundStyle(Color.slate600)
        }
        .padding(.vertical, 8)
    }
}
