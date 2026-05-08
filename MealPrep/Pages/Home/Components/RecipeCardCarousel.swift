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
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            
            // MARK: - Section Header
            HStack {
                Text(title)
                    .font(Theme.Typography.heading)
                    .foregroundStyle(Theme.Colors.textPrimary)
                
                Spacer()
                
                Button("See all →") {
                    // navigate to full list
                }
                .font(Theme.Typography.body)
                .foregroundStyle(Theme.Colors.primary)
            }
            .padding(.horizontal, Theme.Spacing.md)
            
            // MARK: - Horizontal Scroll
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Theme.Spacing.sm) {
                    ForEach(recipes) { recipe in
                        RecipeCard(recipe: recipe)
                    }
                }
                .padding(.horizontal, Theme.Spacing.md)
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
        }
    }
}

#Preview {
    RecipeCardCarousel(
        title: "What's Trending",
        recipes: RecipeMockData.recipes
    )
    .padding(.vertical)
}
