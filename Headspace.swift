//
//  EunoiaApp.swift
//  Eunoia
//
//  Created by Keno Göllner  on 20.07.25.
//

import SwiftUI

@main
struct EunoiaApp: App {
    let viewModel = MoodLoggingViewModel()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(viewModel)
                .onAppear {
                    NotificationManager.shared.requestAuthorization()
                }
        }
    }
}
