//
//  SetsAndRoundsView.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-13.
//

import SwiftUI
import SwiftData

struct SetsAndRoundsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var configurations: [TabataConfiguration]
    
    private var viewModel: StartViewModel = StartViewModel()
    
    var body: some View {
        HStack {
            // Sets
            VStack {
                HStack() {
                    ControlButton(icon: Icons.minus.rawValue, backgroundColor: .gray.opacity(0.2), foregroundColor: .primary, size: 50, iconSize: 20) {
                        viewModel.updateSets(by: -1, configurations: configurations)
                    }
                    Text("\(configurations.first?.sets ?? 0)")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .frame(width: 60)
                        .multilineTextAlignment(.center)
                    
                    ControlButton(icon: Icons.plus.rawValue, backgroundColor: .gray.opacity(0.2), foregroundColor: .primary, size: 50, iconSize: 20) {
                        viewModel.updateSets(by: 1, configurations: configurations)
                    }
                    
                }
                Text("Sets")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
            }
            Spacer()
            // Rounds
            VStack {
                HStack() {
                    ControlButton(icon: Icons.minus.rawValue, backgroundColor: .gray.opacity(0.2), foregroundColor: .primary, size: 50, iconSize: 20) {
                        viewModel.updateRounds(by: -1, configurations: configurations)
                    }
                    Text("\(configurations.first?.rounds ?? 0)")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .frame(width: 60)
                        .multilineTextAlignment(.center)
                    
                    ControlButton(icon: Icons.plus.rawValue, backgroundColor: .gray.opacity(0.2), foregroundColor: .primary, size: 50, iconSize: 20) {
                        viewModel.updateRounds(by: 1, configurations: configurations)
                    }
                }
                Text("Rounds")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
            }
        }
        .background(.gray.opacity(0.3)) // Debug
    }
}

#Preview {
    SetsAndRoundsView()
        .modelContainer(for: TabataConfiguration.self, inMemory: true)
}
