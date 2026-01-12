//
//  HapticManager.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-12.
//

import UIKit

final class HapticManager {
    static let shared = HapticManager()
    
    private init() {}
    
    func play(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
    
    func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}
