//
//  SavedRecipeTab.swift
//
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//

//import SwiftUI
//
//struct SavedRecipeTab: View {
//    //@Environment(UserLibrary.self) private var userLibrary
//    
//    var body: some View {
//        if userLibrary.likedRecipes.isEmpty {
//            VStack(spacing: Theme.Spacing.md) {
//                Image(systemName: "heart.slash")
//                    .font(.system(size: 40))
//                    .foregroundStyle(Theme.Colors.textTertiary)
//                Text("No saved recipes yet")
//                    .font(Theme.Typography.heading)
//                    .foregroundStyle(Theme.Colors.textPrimary)
//                Text("Like recipes to save them here")
//                    .font(Theme.Typography.body)
//                    .foregroundStyle(Theme.Colors.textSecondary)
//            }
//            .padding(.top, Theme.Spacing.xl)
//        } else {
//            LazyVGrid(
//                columns: [
//                    GridItem(.flexible(), spacing: Theme.Spacing.md),
//                    GridItem(.flexible(), spacing: Theme.Spacing.md)
//                ],
//                spacing: Theme.Spacing.md
//            ) {
//                ForEach(userLibrary.likedRecipes) { recipe in
//                    VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
//                        ZStack(alignment: .topTrailing) {
//                            RecipeCard(recipe: recipe)
//                            Image(systemName: "bookmark.fill")
//                                .font(.system(size: 15, weight: .semibold))
//                                .foregroundStyle(Theme.Colors.primary)
//                                .padding(9)
//                                .background(.white.opacity(0.95))
//                                .clipShape(Circle())
//                                .padding(10)
//                        }
//                        Text(recipe.title)
//                            .font(.system(size: 15, weight: .medium))
//                            .foregroundStyle(Theme.Colors.textPrimary)
//                            .fixedSize(horizontal: false, vertical: true)
//                    }
//                }
//            }
//            .padding(.horizontal, Theme.Spacing.md)
//            .padding(.top, Theme.Spacing.lg)
//        }
//    }
//}
import SwiftUI

struct SavedRecipeTab: View {
    
    var body: some View {
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
        .padding(.top, Theme.Spacing.xl)
    }
}
