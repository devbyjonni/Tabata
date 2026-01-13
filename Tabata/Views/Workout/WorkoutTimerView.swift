//
//  WorkoutTimerView.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI

struct WorkoutTimerView: View {
    var viewModel: WorkoutViewModel
    
    var body: some View {
        ZStack {
            // Background Circle
            Circle()
                .stroke(lineWidth: 20)
                .opacity(0.3)
                .foregroundColor(.gray)
            
            // Progress Circle
            Circle()
                .trim(from: 0.0, to: viewModel.progress)
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                .foregroundColor(.blue)
                .rotationEffect(Angle(degrees: 270.0))
            
            // Time Text
            Text(viewModel.timeRemaining.formatTime())
                .font(.system(size: 80, weight: .black, design: .rounded)) // Slightly smaller to fit
                .monospacedDigit()
        }
        .padding()
    }
}

#Preview {
    WorkoutTimerView(viewModel: WorkoutViewModel())
}
