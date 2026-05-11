//
//  InventorySuggestionCarousel.swift
//  
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//

import SwiftUI

struct InventorySuggestionsCarousel: View {
    let inventory: [InventoryItem]
    var onRecipeTap: ((Recipe) -> Void)? = nil
    
    // Match recipes to inventory items
    var suggestedRecipes: [(recipe: Recipe, matchedItem: InventoryItem)] {
        var results: [(Recipe, InventoryItem)] = []
        
        for item in inventory {
            for recipe in MockRecipes.all {
                let ingredientNames = recipe.ingredients.map { $0.name.lowercased() }
                let itemName = item.name.lowercased()
                
                if ingredientNames.contains(where: { $0.contains(itemName) || itemName.contains($0) }) {
                    if !results.contains(where: { $0.0.id == recipe.id }) {
                        results.append((recipe, item))
                    }
                }
            }
        }
        return results
    }
    
    var body: some View {
        if !suggestedRecipes.isEmpty {
            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                
                // MARK: - Section Header
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Pantry Suggestions")
                            .font(Theme.Typography.heading)
                            .foregroundStyle(Theme.Colors.textPrimary)
                        Text("Based on your recent grocery haul")
                            .font(Theme.Typography.micro)
                            .foregroundStyle(Theme.Colors.textSecondary)
                    }
                    
                    Spacer()
                    
                    Button("See all →") {
                    }
                    .font(Theme.Typography.body)
                    .foregroundStyle(Theme.Colors.primary)
                }
                .padding(.horizontal, Theme.Spacing.md)
                
                // MARK: - Horizontal Scroll
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Theme.Spacing.sm) {
                        ForEach(suggestedRecipes, id: \.recipe.id) { suggestion in
                            PantrySuggestionCard(
                                recipe: suggestion.recipe,
                                matchedItem: suggestion.matchedItem
                            ) {
                                onRecipeTap?(suggestion.recipe)
                            }
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.md)
                }
            }
        }
    }
}

struct PantrySuggestionCard: View {
    let recipe: Recipe
    let matchedItem: InventoryItem
    var onTap: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            
            // Icon
            ZStack {
                Circle()
                    .fill(Theme.Colors.primaryLight)
                    .frame(width: 48, height: 48)
                
                Image(systemName: iconFor(category: matchedItem.category))
                    .foregroundStyle(Theme.Colors.primary)
                    .font(.system(size: 22))
            }
            
            // Matched item
            Text("Use your \(Int(matchedItem.quantity)) \(matchedItem.name)")
                .font(Theme.Typography.subhead)
                .foregroundStyle(Theme.Colors.textPrimary)
                .lineLimit(2)
            
            // Recipe suggestion
            Text(recipe.name)
                .font(Theme.Typography.micro)
                .foregroundStyle(Theme.Colors.textSecondary)
                .lineLimit(1)
            
            // View Recipe button
            Text("View Recipe")
                .font(Theme.Typography.micro)
                .foregroundStyle(Theme.Colors.primary)
                .padding(.horizontal, Theme.Spacing.sm)
                .padding(.vertical, Theme.Spacing.xs)
                .background(Theme.Colors.background)
                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.pill))
                .overlay {
                    RoundedRectangle(cornerRadius: Theme.Radius.pill)
                        .stroke(Theme.Colors.primary, lineWidth: 1)
                }
                .onTapGesture {
                    onTap?()
                }
        }
        .padding(Theme.Spacing.md)
        .frame(width: 160)
        .background(Theme.Colors.primaryLight)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
        .onTapGesture {
            onTap?()
        }
    }
    
    func iconFor(category: InventoryCategory) -> String {
        switch category {
        case .produce: return "leaf.fill"
        case .dairy: return "cup.and.saucer.fill"
        case .pantry: return "cabinet.fill"
        case .meat: return "fork.knife"
        case .frozen: return "snowflake"
        }
    }
}

#Preview {
    NavigationStack {
        InventorySuggestionsCarousel(inventory: DefaultInventoryItems.all)
            .padding(.vertical)
    }
}
