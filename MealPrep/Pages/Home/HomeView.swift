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
            VStack(spacing: 0) {
                
                // Top Bar
                HStack {
                    Button {
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
                    
                    Spacer()
                    
                    Text("MealPrep")
                        .font(Theme.Typography.heading)
                        .foregroundStyle(Theme.Colors.primary)
                    
                    Spacer()
                    
                    Button {
                    } label: {
                        Image(systemName: "bell")
                            .foregroundStyle(Theme.Colors.textPrimary)
                            .font(.system(size: 18))
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
                            recipes: MockRecipes.all,
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

