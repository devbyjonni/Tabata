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
            VStack(spacing: 20) {
                Image("SpashScreenImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 36, style: .continuous))
                    .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
                Text("TABATA PRO")
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .tracking(4)
                    .foregroundStyle(.white)
                    .opacity(0.8)
            }
            .scaleEffect(scale)
            .opacity(opactiy)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.slate900)
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                self.opactiy = 1.0
                self.scale = 1.0
            }
        }
    }
}
