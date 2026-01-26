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
    
    /// Prepares the haptic engine to reduce latency.
    func prepare() {
        guard isHapticsEnabled else { return }
        // Warming up all types of feedback generators
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.prepare()
        
        let notification = UINotificationFeedbackGenerator()
        notification.prepare()
        
        let selection = UISelectionFeedbackGenerator()
        selection.prepare()
    }
}
