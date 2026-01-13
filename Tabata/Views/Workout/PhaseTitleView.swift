//
//  PhaseTitleView.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI

struct PhaseTitleView: View {
    let phase: WorkoutPhase
    
    var body: some View {
        HStack {
            Text(phase.rawValue.uppercased())
                .font(.system(size: 40, weight: .black, design: .rounded))
        }
        .background(.gray.opacity(0.3)) // Debug
    }
}

#Preview {
    PhaseTitleView(phase: .work)
}
