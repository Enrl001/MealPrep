//
//  SavedRecipeTab.swift
//
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//

import SwiftUI

struct SavedRecipeTab: View {
    @Environment(UserLibrary.self) private var userLibrary
    var onRecipeTap: ((Recipe) -> Void)? = nil

    private let columns = [
        GridItem(.flexible(), spacing: Theme.Spacing.md),
        GridItem(.flexible(), spacing: Theme.Spacing.md)
    ]

    var body: some View {
        if userLibrary.likedRecipes.isEmpty {
            emptyState
        } else {
            LazyVGrid(columns: columns, spacing: Theme.Spacing.md) {
                ForEach(userLibrary.likedRecipes) { recipe in
                    Button {
                        onRecipeTap?(recipe)
                    } label: {
                        ZStack(alignment: .topTrailing) {
                            RecipeCard(recipe: recipe)

                            Image(systemName: "heart.fill")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Theme.Colors.tertiary)
                                .frame(width: 32, height: 32)
                                .background(Theme.Colors.background.opacity(0.95))
                                .clipShape(Circle())
                                .padding(Theme.Spacing.sm)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, Theme.Spacing.md)
            .padding(.top, Theme.Spacing.lg)
        }
    }

    private var emptyState: some View {
        VStack(spacing: Theme.Spacing.md) {
            Image(systemName: "heart.slash")
                .font(.system(size: 40))
                .foregroundStyle(Theme.Colors.textTertiary)

            Text("No saved recipes yet")
                .font(Theme.Typography.heading)
                .foregroundStyle(Theme.Colors.textPrimary)

            Text("Like recipes to save them here")
                .font(Theme.Typography.body)
                .foregroundStyle(Theme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, Theme.Spacing.xl)
    }
}
