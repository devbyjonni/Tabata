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
    
    
    init(timestamp: Date = Date(),
         sets: Int = 10,
         rounds: Int  = 10,
         warmUpTime: Double  = 10,
         workTime: Double  = 10,
         restTime: Double  = 10,
         coolDownTime: Double  = 10) {
        
        self.timestamp = timestamp
        self.sets = sets
        self.rounds = rounds
        
        self.warmUpTime = warmUpTime
        self.workTime = workTime
        self.restTime = restTime
        self.coolDownTime = coolDownTime
    }
}
