//
//  CompletedWorkout.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-14.
//

import Foundation
import SwiftData

/// Represents a finished workout session for persistence.
@Model
final class CompletedWorkout: Identifiable {
    @Attribute(.unique) var id: UUID
    var date: Date
    
    // Durations in seconds
    var duration: TimeInterval
    var totalWarmUp: TimeInterval
    var totalWork: TimeInterval
    var totalRest: TimeInterval
    var totalCoolDown: TimeInterval
    
    // Health Metrics (Estimated or Placeholder)
    var calories: Int
    var avgHeartRate: Int
    
    init(date: Date = Date(), 
         duration: TimeInterval, 
         totalWarmUp: TimeInterval, 
         totalWork: TimeInterval, 
         totalRest: TimeInterval, 
         totalCoolDown: TimeInterval, 
         calories: Int = 0, 
         avgHeartRate: Int = 0) {
        self.id = UUID()
        self.date = date
        self.duration = duration
        self.totalWarmUp = totalWarmUp
        self.totalWork = totalWork
        self.totalRest = totalRest
        self.totalCoolDown = totalCoolDown
        self.calories = calories
        self.avgHeartRate = avgHeartRate
    }
}
