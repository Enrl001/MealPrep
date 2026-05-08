//
//  HomeView.swift
//  
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//

import SwiftUI

struct HomeView: View {
    @State private var searchText = ""
    @State private var selectedCuisine = "Italian"
    @State private var selectedRecipe: Recipe? = nil

    
    let cuisines = ["Italian", "Mexican", "Vegan", "Japanese", "Chinese"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                    
                    // MARK: - Search Bar
                    SearchBarView(searchText: $searchText)
                        .padding(.horizontal, Theme.Spacing.md)
                    
                    // MARK: - Cuisine Filter Chips
                    CuisineFilterChips(
                        cuisines: cuisines,
                        selected: $selectedCuisine
                    )
                    
                    // MARK: - What's Trending
                    RecipeCardCarousel(
                        title: "What's Trending",
                        recipes: MockRecipes.all
                    )
                    
                    // MARK: - Trending Food Bloggers
                    TrendingPeopleCarousel(
                        bloggers: BloggerMockData.bloggers
                    )
                    
                }
                .padding(.vertical, Theme.Spacing.md)
            }
            .background(Theme.Colors.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                // Profile avatar (left)
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        // navigate to profile
                    } label: {
                        Circle()
                            .fill(Theme.Colors.surface)
                            .frame(width: 32, height: 32)
                            .overlay {
                                Image(systemName: "person.fill")
                                    .foregroundStyle(Theme.Colors.textSecondary)
                                    .font(.system(size: 14))
                            }
                    }
                }
                
                // App title (center)
                ToolbarItem(placement: .principal) {
                    Text("MealPrep")
                        .font(Theme.Typography.heading)
                        .foregroundStyle(Theme.Colors.primary)
                }
                
                // Bell icon (right)
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // notifications
                    } label: {
                        Image(systemName: "bell")
                            .foregroundStyle(Theme.Colors.textPrimary)
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
