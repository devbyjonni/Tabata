//
//  TimeInterval+Extensions.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-12.
//

import Foundation

extension TimeInterval {
    func formatTime() -> String {
        let totalSeconds = Int(ceil(self))
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}
