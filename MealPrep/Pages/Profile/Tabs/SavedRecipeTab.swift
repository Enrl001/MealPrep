//
//  SavedRecipeTab.swift
//
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//

import SwiftUI

struct SavedRecipeTab: View {
    let recipes: [Recipe]

    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: Theme.Spacing.md),
                GridItem(.flexible(), spacing: Theme.Spacing.md)
            ],
            spacing: Theme.Spacing.md
        ) {
            ForEach(recipes) { recipe in
                VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                    ZStack(alignment: .topTrailing) {
                        RecipeCard(recipe: recipe)
                        Image(systemName: "bookmark")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(Theme.Colors.primary)
                            .padding(9)
                            .background(.white.opacity(0.95))
                            .clipShape(Circle())
                            .padding(10)
                    }

                    Text(recipe.title)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(Theme.Colors.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(.horizontal, Theme.Spacing.md)
        .padding(.top, Theme.Spacing.lg)
    }
}

