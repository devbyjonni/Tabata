//
//  TimeInterval+Extensions.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-12.
//

import Foundation

extension TimeInterval {
    func formatTime() -> String {
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
