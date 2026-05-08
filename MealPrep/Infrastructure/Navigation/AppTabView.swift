//
//  AppTabView.swift
//  
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//
import SwiftUI

struct AppTabView: View {
    var body: some View {
        TabView {
            PotluckView()
                .tabItem {
                    Label("Potluck", systemImage: "fork.knife")
                }
            GroceryListView()
                .tabItem {
                    Label("Grocery", systemImage: "cart")
                }
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            ScheduleView()
                .tabItem {
                    Label("Schedule", systemImage: "calendar")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
        .tint(Color(hex: "#FE9900")) 
    }
}
