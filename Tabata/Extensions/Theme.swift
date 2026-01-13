//
//  Theme.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI

struct Theme {
    /// Green - Used for Primary actions (Play) and Work phase
    static let primary = Color(hex: "22c55e")
    
    /// Light Gray/White - Main background for light mode
    static let background = Color(hex: "F8FAFC")
    
    /// Orange - Warm Up phase background
    static let warmup = Color(hex: "f97316")
    
    /// Green - Work phase background
    static let work = Color(hex: "22c55e")
    
    /// Red - Rest phase background
    static let rest = Color(hex: "ef4444")
    
    /// Blue - Cool Down phase background
    static let cooldown = Color(hex: "3b82f6")
}

extension Color {
    // MARK: - Slate Grays
    /// Very Dark Blue/Gray - Main background for Dark Mode, Primary Text for Light Mode
    static let slate900 = Color(hex: "0F172A")
    
    /// Very Light Gray - Secondary backgrounds
    static let slate100 = Color(hex: "F1F5F9")
    
    /// Light Gray - UI Elements, Borders
    static let slate200 = Color(hex: "E2E8F0")
    
    /// Medium Gray - Inactive states
    static let slate300 = Color(hex: "CBD5E1")
    
    /// Dark Gray - Secondary Text, Subtitles
    static let slate400 = Color(hex: "94A3B8")
    
    /// Adaptive Primary Text Color
    static var primaryText: Color { Color.slate900 }
    
    // MARK: - Hex Initializer
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}
