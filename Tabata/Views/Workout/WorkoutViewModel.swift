//
//  WorkoutViewModel.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-12.
//

import Foundation
import Observation

@Observable
final class WorkoutViewModel {
    var phase: WorkoutPhase = .idle
    var timeRemaining: Double = 0
    var totalTime: Double = 1 // Avoid division by zero
    var isActive: Bool = false
    
    var progress: Double {
        guard totalTime > 0 else { return 0 }
        return timeRemaining / totalTime
    }
    
    /// Starts the workout with the given configuration.
    /// Currently only handles the Warm Up phase.
    func start(config: TabataConfiguration) {
        self.phase = .warmUp
        self.timeRemaining = config.warmUpTime
        self.totalTime = config.warmUpTime > 0 ? config.warmUpTime : 1
        self.isActive = true
    }
    
    /// Ticks the timer down by 1 second.
    func tick() {
        guard isActive else { return }
        
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            // Timer finished for this phase
            isActive = false
            // Future: Transition to next phase
        }
    }
    
    /// Stops the workout.
    func stop() {
        isActive = false
        phase = .idle
        timeRemaining = 0
    }
}
