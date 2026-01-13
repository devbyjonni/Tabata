//
//  StatItemView.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI

struct StatItemView: View {
    let title: String
    let current: Int
    let total: Int
    
    var body: some View {
        VStack {
            Text(title)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
            Text("\(current) of \(total)")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .fontWeight(.bold)
                .monospacedDigit()
        }
    }
}

#Preview {
    StatItemView(title: "Sets", current: 1, total: 8)
}
