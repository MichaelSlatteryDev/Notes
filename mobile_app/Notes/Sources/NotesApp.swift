//
//  NotesApp.swift
//  Notes
//
//  Created by Michael Slattery on 5/31/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct NotesApp: App {
    static let store = Store(initialState: LoginFeature.State()) {
        LoginFeature()
            ._printChanges()
    }
    
    var body: some Scene {
        WindowGroup {
            
            LoginView(store: Self.store)
        }
    }
}
