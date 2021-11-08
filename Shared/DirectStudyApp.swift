//
//  DirectStudyApp.swift
//  Shared
//
//  Created by Justin Fulkerson on 10/24/21.
//

import SwiftUI

@main
struct DirectStudyApp: App {
    @StateObject var authenticator = Authenticator()
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authenticator)
            //ContentView()
        }
    }
}
