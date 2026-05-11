//
//  AppTabView.swift
//  
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//
import SwiftUI

struct AppTabView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var router = AppRouter()
    var userLibrary = UserLibrary.shared
    
    var body: some View {
        TabView(selection: $router.selectedTab) {
            PotluckView()
                .tabItem {
                    Label("Potluck", systemImage: "fork.knife")
                }
                .tag(AppTab.potluck)
            GroceryListView()
                .tabItem {
                    Label("Grocery", systemImage: "cart")
                }
                .tag(AppTab.grocery)
            HomeView()
                .tabItem {
                    Label {
                        Text("Home")
                    } icon: {
                        Image(systemName: "house")
                            .symbolVariant(.none)
                    }
                }
                .tag(AppTab.home)
            ScheduleView()
                .tabItem {
                    Label("Schedule", systemImage: "calendar")
                }
                .tag(AppTab.schedule)
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
                .tag(AppTab.profile)
        }
        .environmentObject(authViewModel)
        .environmentObject(router)
        .environment(userLibrary)
        .tint(Theme.Colors.primary)
    }
}
