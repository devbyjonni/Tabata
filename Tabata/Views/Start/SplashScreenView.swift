    //
//  SplashScreenView.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-15.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var opactiy = 0.0
    @State private var scale = 0.8
    
    var body: some View {
        ZStack {
           Color.slate900.ignoresSafeArea()
            
            VStack(spacing: 20) {
                if let icon = Bundle.main.icon {
                    Image(uiImage: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 36, style: .continuous))
                        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
                } else {
                    // Fallback if icon is not found (preview or asset issue)
                    Image(systemName: "figure.highintensity.intervaltraining")
                        .font(.system(size: 100))
                        .foregroundStyle(Theme.primary)
                }
                
                Text("TABATA PRO")
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .tracking(4)
                    .foregroundStyle(.white)
                    .opacity(0.8)
            }
            .scaleEffect(scale)
            .opacity(opactiy)
        }
        .background(Color.slate900)
        .preferredColorScheme(.dark)
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                self.opactiy = 1.0
                self.scale = 1.0
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
