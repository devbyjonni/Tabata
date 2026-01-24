//
//  TabataConfiguration.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-12.
//

import Foundation
import SwiftData

@Model
final class TabataConfiguration {
    var timestamp: Date
    var sets: Int
    var rounds: Int
    var warmUpTime: Double
    var workTime: Double
    var restTime: Double
    var coolDownTime: Double
    
    // Advanced Settings
    var restBetweenRounds: Double
    
    
    init(timestamp: Date = Date(),
         sets: Int = 8,
         rounds: Int  = 3,
         warmUpTime: Double  = 60,
         workTime: Double  = 20,
         restTime: Double  = 10,
         coolDownTime: Double  = 60,
         restBetweenRounds: Double = 60) {
        
        self.timestamp = timestamp
        self.sets = sets
        self.rounds = rounds
        
        self.warmUpTime = warmUpTime
        self.workTime = workTime
        self.restTime = restTime
        self.coolDownTime = coolDownTime
        self.restBetweenRounds = restBetweenRounds
    }
    
    var totalDuration: Double {
        let cycleDuration = (workTime + restTime) * Double(sets)
        var total = warmUpTime + (cycleDuration * Double(rounds))
        
        // Add Cool Down
        total += coolDownTime
        
        // If multiple rounds, swap the last Rest of each previous round with RestBetweenRounds
        if rounds > 1 {
            let swaps = Double(rounds - 1)
            total -= (restTime * swaps)
            total += (restBetweenRounds * swaps)
        }
        
        // Remove the very last Rest period (as workout ends on Work/Cool Down)
        total -= restTime
        
        return total
    }
}
