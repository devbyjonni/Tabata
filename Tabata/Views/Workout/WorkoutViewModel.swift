//
//  WorkoutViewModel.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-12.
//

import Foundation

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
    
    private var config: TabataConfiguration?
    var currentSet = 1
    var currentRound = 1
    
    /// Starts the workout with the given configuration.
    func start(config: TabataConfiguration) {
        self.config = config
        self.currentSet = 1
        self.currentRound = 1
        
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
            nextPhase()
        }
    }
    
    private func nextPhase() {
        guard let config = config else { return }
        
        switch phase {
        case .idle:
            break
            
        case .warmUp:
            phase = .work
            timeRemaining = config.workTime
            totalTime = config.workTime > 0 ? config.workTime : 1
            
        case .work:
            // Check if workout is complete
            if currentSet == config.sets && currentRound == config.rounds {
                phase = .coolDown
                timeRemaining = config.coolDownTime
                totalTime = config.coolDownTime > 0 ? config.coolDownTime : 1
            } else {
                phase = .rest
                timeRemaining = config.restTime
                totalTime = config.restTime > 0 ? config.restTime : 1
            }
            
        case .rest:
            if currentSet < config.sets {
                currentSet += 1
                phase = .work
                timeRemaining = config.workTime
                totalTime = config.workTime > 0 ? config.workTime : 1
            } else if currentRound < config.rounds {
                currentRound += 1
                currentSet = 1
                phase = .work
                timeRemaining = config.workTime
                totalTime = config.workTime > 0 ? config.workTime : 1
            } else {
                // Safety fallback, should be caught in Work phase
                phase = .coolDown
                timeRemaining = config.coolDownTime
                totalTime = config.coolDownTime > 0 ? config.coolDownTime : 1
            }
            
        case .coolDown:
            phase = .idle
            isActive = false
            timeRemaining = 0
        }
    }
    
    /// Stops the workout.
    func stop() {
        isActive = false
        phase = .idle
        timeRemaining = 0
    }
}
