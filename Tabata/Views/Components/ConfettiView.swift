//
//  ConfettiView.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-15.
//

import SwiftUI
import Combine

/// A fun confetti celebration view.
/// Uses a timer to drive a simple physics simulation for particles.
struct ConfettiView: View {
    @State private var confetti: [ConfettiParticle] = []
    
    // Timer to update physics
    let timer = Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(confetti) { particle in
                    ConfettiParticleView(particle: particle)
                }
            }
            .onAppear {
                spawnConfetti(count: 50, in: geometry.size)
            }
            .onReceive(timer) { _ in
                updatePhysics(in: geometry.size)
            }
        }
        .allowsHitTesting(false) // Let touches pass through
    }
    
    private func spawnConfetti(count: Int, in size: CGSize) {
        for _ in 0..<count {
            confetti.append(ConfettiParticle(
                position: CGPoint(x: CGFloat.random(in: 0...size.width), y: -50), // Start above screen
                velocity: CGPoint(x: CGFloat.random(in: -2...2), y: CGFloat.random(in: 2...8)),
                color: [Color.red, Color.blue, Color.green, Color.yellow, Color.orange, Color.purple].randomElement()!,
                rotation: Double.random(in: 0...360),
                rotationSpeed: Double.random(in: -5...5)
            ))
        }
    }
    
    private func updatePhysics(in size: CGSize) {
        for i in confetti.indices {
            // Gravity
            confetti[i].velocity.y += 0.1
            
            // Movement
            confetti[i].position.x += confetti[i].velocity.x
            confetti[i].position.y += confetti[i].velocity.y
            
            // Rotation
            confetti[i].rotation += confetti[i].rotationSpeed
            
            // Sway (X oscillation)
            confetti[i].velocity.x += CGFloat.random(in: -0.1...0.1)
        }
        
        // Optimization: In a real app we'd remove off-screen particles
    }
}

// MARK: - Models

struct ConfettiParticle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var velocity: CGPoint
    let color: Color
    var rotation: Double
    let rotationSpeed: Double
}

struct ConfettiParticleView: View {
    let particle: ConfettiParticle
    
    var body: some View {
        Rectangle()
            .fill(particle.color)
            .frame(width: 8, height: 8)
            .position(particle.position)
            .rotationEffect(.degrees(particle.rotation))
    }
}

// MARK: - Preview

#Preview {
    ConfettiView()
        .background(Color.black)
}
