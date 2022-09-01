//
//  NYCSVApp.swift
//  Shared
//
//  Created by Ivan Lugo on 8/31/22.
//

import SwiftUI

@main
struct NYCSVApp: App {
    @StateObject var appState = NYCSVAppState()
    
    var body: some Scene {
        WindowGroup {
            NYCSVRoot()
                .environmentObject(appState)
                .onAppear { appState.startRootLoad() }
        }
    }
}
