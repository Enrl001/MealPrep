//
//  MealPrepApp.swift
//  MealPrep
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//

import SwiftUI

@main
struct MealPrepApp: App {
    @StateObject var authVM = AuthViewModel()
    var userLibrary = UserLibrary.shared
    
    var body: some Scene {
        WindowGroup {
            AppTabView()
                .environmentObject(authVM)
                .environment(userLibrary)
        }
    }
}
