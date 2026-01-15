//
//  HapticManager.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-12.
//

import UIKit

final class HapticManager {
    static let shared = HapticManager()
    
    var isHapticsEnabled: Bool = true
    
    private init() {}
    
    func play(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        guard isHapticsEnabled else { return }
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
    
    func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        guard isHapticsEnabled else { return }
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
    
    func selection() {
        guard isHapticsEnabled else { return }
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
}
