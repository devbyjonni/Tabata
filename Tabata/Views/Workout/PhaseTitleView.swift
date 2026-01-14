//
//  PhaseTitleView.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI

/// Displays the name of the current workout phase (e.g., "WARM UP", "WORK").
/// Updates with animation as the phase changes.
struct PhaseTitleView: View {
    let phase: WorkoutPhase
    
    var body: some View {
        HStack {
            Text(phase.rawValue.uppercased())
                .font(.system(size: 40, weight: .black, design: .rounded))
        }
    }
}

#Preview {
    PhaseTitleView(phase: .work)
}
