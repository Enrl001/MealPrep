//
//  MyRecipesTab.swift
//
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//

import SwiftUI

struct MyRecipesTab: View {
    @EnvironmentObject private var authVM: AuthViewModel
    @State private var recipes: [Recipe] = []
    @State private var isShowingCreator = false

    var onRecipeTap: (Recipe) -> Void = { _ in }

    private var currentUser: User? {
        authVM.currentUser
    }

    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: Theme.Spacing.md),
                GridItem(.flexible(), spacing: Theme.Spacing.md)
            ],
            spacing: Theme.Spacing.md
        ) {
            createRecipeTile

            ForEach(recipes) { recipe in
                ZStack(alignment: .topTrailing) {
                    RecipeCard(recipe: recipe) {
                        onRecipeTap(recipe)
                    }

                    HStack(spacing: 3) {
                        Image(systemName: recipe.isPublic ? "globe" : "lock")
                            .font(.system(size: 10, weight: .semibold))
                        Text(recipe.isPublic ? "Public" : "Private")
                            .font(Theme.Typography.micro)
                    }
                    .foregroundStyle(Theme.Colors.textSecondary)
                    .padding(.horizontal, Theme.Spacing.xs)
                    .padding(.vertical, 3)
                    .background(Theme.Colors.background.opacity(0.95))
                    .clipShape(Capsule())
                    .padding(Theme.Spacing.xs)
                }
                .frame(width: 160, height: 220)
            }
        }
        .padding(Theme.Spacing.md)
        .onAppear(perform: loadMyRecipes)
        .onChange(of: authVM.currentUser?.id) { _, _ in
            loadMyRecipes()
        }
        .sheet(isPresented: $isShowingCreator) {
            RecipeCreatorView(authorUsername: currentUser?.username ?? "") { recipe in
                addRecipe(recipe)
            }
        }
    }

    private var createRecipeTile: some View {
        Button {
            isShowingCreator = true
        } label: {
            VStack(spacing: Theme.Spacing.md) {
                Image(systemName: "plus")
                    .font(.system(size: Theme.IconSize.lg, weight: .semibold))
                    .foregroundStyle(Theme.Colors.primary)
                    .frame(width: 54, height: 54)
                    .background(Theme.Colors.primaryLight)
                    .clipShape(Circle())

                VStack(spacing: Theme.Spacing.xs) {
                    Text("Create Recipe")
                        .font(Theme.Typography.subhead)
                        .foregroundStyle(Theme.Colors.textPrimary)
                    Text("Add a new dish")
                        .font(Theme.Typography.micro)
                        .foregroundStyle(Theme.Colors.textSecondary)
                }
                .multilineTextAlignment(.center)
            }
            .frame(width: 160, height: 220)
            .background(Theme.Colors.background)
            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
            .overlay(
                RoundedRectangle(cornerRadius: Theme.Radius.md)
                    .stroke(Theme.Colors.primary, style: StrokeStyle(lineWidth: 1, dash: [5, 5]))
            )
        }
        .buttonStyle(.plain)
        .disabled(currentUser == nil)
    }

    private func loadMyRecipes() {
        guard let userID = currentUser?.id else {
            recipes = []
            return
        }

        recipes = loadRecipes(for: userID)
    }

    private func addRecipe(_ recipe: Recipe) {
        guard let userID = currentUser?.id else { return }

        var updatedRecipes = loadRecipes(for: userID)
        updatedRecipes.insert(recipe, at: 0)
        saveRecipes(for: userID, recipes: updatedRecipes)
        recipes = updatedRecipes
    }
}
