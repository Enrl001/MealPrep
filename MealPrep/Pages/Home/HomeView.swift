//
//  HomeView.swift
//  
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//

import SwiftUI

struct HomeView: View {
    @State private var searchText = ""
    @State private var selectedCuisine = "All"
    @State private var selectedRecipe: Recipe? = nil
    
    
    let cuisines = ["All", "Italian", "Mexican", "Vegan", "Japanese", "Chinese"]
    
    var filteredRecipes: [Recipe] {
        if selectedCuisine == "All" {
            return MockRecipes.all
        }
        return MockRecipes.all.filter {
            $0.cuisine.lowercased() == selectedCuisine.lowercased()
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                // Top Bar
                ZStack {
                    Text("MealPrep")
                        .font(Theme.Typography.heading)
                        .foregroundStyle(Theme.Colors.primary)
                    
                    HStack {
                        Button {
                        } label: {
                            Image(systemName: "bell")
                                .foregroundStyle(Theme.Colors.textPrimary)
                                .font(.system(size: 18))
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal, Theme.Spacing.md)
                .padding(.vertical, Theme.Spacing.sm)
                .background(Theme.Colors.background)
                
                Divider()
                
                // Scrollable Content
                ScrollView {
                    VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                        
                        SearchBarView(searchText: $searchText)
                            .padding(.horizontal, Theme.Spacing.md)
                        
                        CuisineFilterChips(
                            cuisines: cuisines,
                            selected: $selectedCuisine
                        )
                        
                        RecipeCardCarousel(
                            title: "What's Trending",
                            recipes: filteredRecipes,
                            onRecipeTap: { recipe in
                                selectedRecipe = recipe
                            }
                        )
                        
                        TrendingPeopleCarousel(
                            bloggers: BloggerMockData.bloggers
                        )
                    }
                    .padding(.vertical, Theme.Spacing.md)
                }
            }
            .background(Theme.Colors.background)
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(item: $selectedRecipe) { recipe in
                RecipeDetailView(recipe: recipe)
            }
        }
    }
}
#Preview {
    HomeView()
        
}

