//
//  ShareSheet.swift
//  Tabata
//
//  Created by Jonni Åkesson on 2026-01-15.
//

import SwiftUI
import UIKit

/// A SwiftUI wrapper for UIActivityViewController.
struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
