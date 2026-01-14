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
    
    init(isSoundEnabled: Bool = true, isCountdownEnabled: Bool = true) {
        self.isSoundEnabled = isSoundEnabled
        self.isCountdownEnabled = isCountdownEnabled
    }
}
