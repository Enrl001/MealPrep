//
//  RecipeCardCarousel.swift
//  
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//
import SwiftUI

struct RecipeCardCarousel: View {
    let title: String
    let recipes: [Recipe]
    var onRecipeTap: ((Recipe) -> Void)? = nil
    
    @State private var selectedRecipe: Recipe? = nil
    @State private var showTrendingPage = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            
            // MARK: - Section Header
            HStack {
                Text(title)
                    .font(Theme.Typography.heading)
                    .foregroundStyle(Theme.Colors.textPrimary)
                
                Spacer()
                
                Button("See all →") {
                    showTrendingPage = true
                }
                .font(Theme.Typography.body)
                .foregroundStyle(Theme.Colors.primary)
            }
            .padding(.horizontal, Theme.Spacing.md)
            
            // MARK: - Horizontal Scroll
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Theme.Spacing.sm) {
                    ForEach(recipes) { recipe in
                        RecipeCard(recipe: recipe){
                            selectedRecipe = recipe
                            onRecipeTap?(recipe)
                        }
                    }
                }
                .padding(.horizontal, Theme.Spacing.md)
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
        }
        .navigationDestination(isPresented: $showTrendingPage) {
            TrendingFoodPage()
            
        }
    }
}

#Preview {
    NavigationStack {
        RecipeCardCarousel(
            title: "What's Trending",
            recipes: MockRecipes.all
        )
        .padding(.vertical)
    }
}
