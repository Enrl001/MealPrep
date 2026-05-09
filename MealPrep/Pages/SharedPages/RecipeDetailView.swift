//
//  RecipeDetailView.swift
//  
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//

//
//  RecipeDetailView.swift
//  MealPrep
//

import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @State private var isLiked = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {

                // MARK: - Hero Image
                AsyncImage(url: URL(string: recipe.imageURL)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Rectangle()
                        .fill(Theme.Colors.surface)
                        .overlay {
                            Image(systemName: "fork.knife")
                                .foregroundStyle(Theme.Colors.textTertiary)
                                .font(.system(size: 40))
                        }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 280)
                .clipped()

                // MARK: - Content
                VStack(alignment: .leading, spacing: Theme.Spacing.lg) {

                    // Title + Like
                    HStack(alignment: .top) {
                        Text(recipe.name)
                            .font(Theme.Typography.hero)
                            .foregroundStyle(Theme.Colors.textPrimary)
                        Spacer()
                    }

                    // Rating
                    HStack(spacing: Theme.Spacing.xs) {
                        ForEach(0..<5) { _ in
                            Image(systemName: "star.fill")
                                .foregroundStyle(Theme.Colors.primary)
                                .font(.system(size: 12))
                        }
                        Text("(\(recipe.reviewCount) Reviews)")
                            .font(Theme.Typography.micro)
                            .foregroundStyle(Theme.Colors.textSecondary)
                    }

                    // MARK: - Info Boxes
                    HStack(spacing: Theme.Spacing.sm) {
                        InfoBox(icon: "clock", label: "Prep Time", value: "\(recipe.cookTimeMinutes) min")
                        InfoBox(icon: "person.2", label: "Servings", value: "\(recipe.servings) ppl")
                        InfoBox(icon: "bolt", label: "Calories", value: "420 kcal")
                    }

                    // MARK: - Ingredients
                    VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                        HStack {
                            Text("Ingredients")
                                .font(Theme.Typography.heading)
                                .foregroundStyle(Theme.Colors.textPrimary)
                            Spacer()
                            Text("\(recipe.ingredients.count) Items")
                                .font(Theme.Typography.micro)
                                .foregroundStyle(Theme.Colors.textSecondary)
                        }
                        ForEach(recipe.ingredients, id: \.name) { ingredient in
                            IngredientRow(ingredient: ingredient)
                        }
                    }

                    // MARK: - Instructions
                    VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                        Text("Instructions")
                            .font(Theme.Typography.heading)
                            .foregroundStyle(Theme.Colors.textPrimary)

                        ForEach(Array(recipe.instructions.enumerated()), id: \.offset) { index, step in
                            HStack(alignment: .top, spacing: Theme.Spacing.sm) {
                                Circle()
                                    .fill(Theme.Colors.primary)
                                    .frame(width: 28, height: 28)
                                    .overlay {
                                        Text("\(index + 1)")
                                            .font(Theme.Typography.micro)
                                            .foregroundStyle(Theme.Colors.background)
                                    }
                                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                                    Text(step.title)
                                        .font(Theme.Typography.subhead)
                                        .foregroundStyle(Theme.Colors.textPrimary)
                                    Text(step.description)
                                        .font(Theme.Typography.body)
                                        .foregroundStyle(Theme.Colors.textSecondary)
                                }
                            }
                            .padding(Theme.Spacing.sm)
                            .background(Theme.Colors.surface)
                            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
                        }
                    }
                }
                .padding(Theme.Spacing.md)
            }
        }
        .background(Theme.Colors.background)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(recipe.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundStyle(Theme.Colors.textPrimary)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isLiked.toggle()
                } label: {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .foregroundStyle(isLiked ? Theme.Colors.tertiary : Theme.Colors.textSecondary)
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Estimated Cost")
                        .font(Theme.Typography.micro)
                        .foregroundStyle(Theme.Colors.textSecondary)
                    Text("$12.50")
                        .font(Theme.Typography.heading)
                        .foregroundStyle(Theme.Colors.textPrimary)
                }
                Spacer()
                Button {
                } label: {
                    HStack {
                        Image(systemName: "fork.knife")
                        Text("Start Cooking")
                    }
                    .font(Theme.Typography.subhead)
                    .foregroundStyle(Theme.Colors.background)
                    .padding(.horizontal, Theme.Spacing.lg)
                    .padding(.vertical, Theme.Spacing.sm)
                    .background(Theme.Colors.primary)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.pill))
                }
            }
            .padding(Theme.Spacing.md)
            .background(Theme.Colors.background)
            .overlay(alignment: .top) { Divider() }
        }
    }
}

// MARK: - InfoBox
struct InfoBox: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: Theme.Spacing.xs) {
            Image(systemName: icon)
                .foregroundStyle(Theme.Colors.primary)
            Text(label)
                .font(Theme.Typography.micro)
                .foregroundStyle(Theme.Colors.textSecondary)
            Text(value)
                .font(Theme.Typography.subhead)
                .foregroundStyle(Theme.Colors.textPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding(Theme.Spacing.sm)
        .background(Theme.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
    }
}

// MARK: - IngredientRow
struct IngredientRow: View {
    let ingredient: Ingredient
    @State private var isChecked = false

    var body: some View {
        HStack(spacing: Theme.Spacing.sm) {
            Button {
                isChecked.toggle()
            } label: {
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .foregroundStyle(isChecked ? Theme.Colors.primary : Theme.Colors.divider)
                    .font(.system(size: 20))
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(ingredient.name)
                    .font(Theme.Typography.body)
                    .foregroundStyle(isChecked ? Theme.Colors.textTertiary : Theme.Colors.textPrimary)
                    .strikethrough(isChecked)
                Text(ingredient.quantity)
                    .font(Theme.Typography.micro)
                    .foregroundStyle(Theme.Colors.textSecondary)
            }
            Spacer()
        }
        .padding(Theme.Spacing.sm)
        .background(Theme.Colors.background)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm))
        .overlay {
            RoundedRectangle(cornerRadius: Theme.Radius.sm)
                .stroke(Theme.Colors.divider, lineWidth: 1)
        }
    }
}

#Preview {
    NavigationStack {
        RecipeDetailView(recipe: MockRecipes.all[0])
    }
}
