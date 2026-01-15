//
//  TabataSettings.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import Foundation
import SwiftData

@Model
final class TabataSettings {
    var isSoundEnabled: Bool = true
    var isCountdownEnabled: Bool = true
    var isVoiceGuideEnabled: Bool = true
    var isHapticsEnabled: Bool = true
    var volume: Double = 1.0
    var countdownDuration: Int = 3
    
    init(isSoundEnabled: Bool = true, isCountdownEnabled: Bool = true, isVoiceGuideEnabled: Bool = true, isHapticsEnabled: Bool = true, volume: Double = 1.0, countdownDuration: Int = 3) {
        self.isSoundEnabled = isSoundEnabled
        self.isCountdownEnabled = isCountdownEnabled
        self.isVoiceGuideEnabled = isVoiceGuideEnabled
        self.isHapticsEnabled = isHapticsEnabled
        self.volume = volume
        self.countdownDuration = countdownDuration
    }
}
