//
//  AppTabView.swift
//  
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//
import SwiftUI

struct AppTabView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var selectedTab = AppTab.home
    var userLibrary = UserLibrary.shared

    private enum AppTab {
        case potluck
        case grocery
        case home
        case schedule
        case profile
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
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
        .environment(userLibrary)
        .tint(Theme.Colors.primary)
    }
}
