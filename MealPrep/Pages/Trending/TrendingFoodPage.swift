//
//  TrendingFoodPage.swift
//  
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//
import SwiftUI

struct TrendingFoodPage: View {
    @State private var searchText = ""
    @State private var selectedFilter = "All Trending"
    @State private var selectedRecipe: Recipe? = nil
    
    let filters = ["All Trending", "Breakfast", "Lunch", "Dinner", "Snack"]
    
    var filteredRecipes: [Recipe] {
        let trending = MockRecipes.all.filter { $0.isTrending }
        if selectedFilter == "All Trending" {
            return trending
        }
        return trending.filter { $0.mealType.lowercased() == selectedFilter.lowercased() }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: - Search Bar
            SearchBarView(searchText: $searchText)
                .padding(.horizontal, Theme.Spacing.md)
                .padding(.vertical, Theme.Spacing.sm)
            
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                    
                    // MARK: - Header
                    VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                        Text("Trending Now")
                            .font(Theme.Typography.hero)
                            .foregroundStyle(Theme.Colors.textPrimary)
                        Text("The most cooked and shared recipes this week.")
                            .font(Theme.Typography.body)
                            .foregroundStyle(Theme.Colors.textSecondary)
                    }
                    .padding(.horizontal, Theme.Spacing.md)
                    
                    // MARK: - Top 3 Featured
                    if filteredRecipes.count > 0 {
                        TrendingLargeCard(recipe: filteredRecipes[0]) {
                                selectedRecipe = filteredRecipes[0]
                        }
                        .padding(.horizontal, Theme.Spacing.md)
                    }
                    // Second + Third — small horizontal cards
                    if filteredRecipes.count > 1 {
                        VStack(spacing: Theme.Spacing.sm) {
                            ForEach(filteredRecipes.dropFirst().prefix(2)) { recipe in
                                TrendingSmallCard(recipe: recipe){
                                        selectedRecipe = recipe
                                }
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.md)
                    }
                    
                    // MARK: - Filter Chips
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: Theme.Spacing.sm) {
                            ForEach(filters, id: \.self) { filter in
                                Button {
                                    selectedRecipe = nil
                                    selectedFilter = filter
                                } label: {
                                    Text(filter)
                                        .font(Theme.Typography.body)
                                        .foregroundStyle(
                                            selectedFilter == filter
                                            ? Theme.Colors.primary
                                            : Theme.Colors.textSecondary
                                        )
                                        .padding(.horizontal, Theme.Spacing.md)
                                        .padding(.vertical, Theme.Spacing.xs)
                                        .background(Theme.Colors.background)
                                        .clipShape(Capsule())
                                        .overlay {
                                            Capsule()
                                                .stroke(
                                                    selectedFilter == filter
                                                    ? Theme.Colors.primary
                                                    : Theme.Colors.divider,
                                                    lineWidth: 1.5
                                                )
                                        }
                                }
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.md)
                    }
                    
                    // MARK: - Rest of recipes
                    if filteredRecipes.count > 3 {
                        VStack(spacing: Theme.Spacing.md) {
                            ForEach(filteredRecipes.dropFirst(3)) { recipe in
                                TrendingLargeCard(recipe: recipe){
                                        selectedRecipe = recipe
                                }
                                .padding(.horizontal, Theme.Spacing.md)
                            }
                        }
                    }
                }
                .padding(.vertical, Theme.Spacing.md)
            }
        }
        .background(Theme.Colors.background)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: Binding(
            get: { selectedRecipe != nil },
            set: { if !$0 { selectedRecipe = nil } }
        )) {
            if let recipe = selectedRecipe {
                RecipeDetailView(recipe: recipe)
            }
        }
    }
}

// MARK: - Large Card
struct TrendingLargeCard: View {
    let recipe: Recipe
    var onTap: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            
            // Image
            ZStack(alignment: .topLeading) {
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
                                .font(.system(size: 30))
                        }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
                
                // Trending badge
                Text("TRENDING")
                    .font(Theme.Typography.micro)
                    .foregroundStyle(Theme.Colors.background)
                    .padding(.horizontal, Theme.Spacing.sm)
                    .padding(.vertical, 4)
                    .background(Theme.Colors.tertiary)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm))
                    .padding(Theme.Spacing.sm)
            }
            
            // Info
            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                Text(recipe.name)
                    .font(Theme.Typography.heading)
                    .foregroundStyle(Theme.Colors.textPrimary)
                
                Text("by \(recipe.authorUsername)")
                    .font(Theme.Typography.micro)
                    .foregroundStyle(Theme.Colors.textSecondary)
                
                HStack(spacing: Theme.Spacing.sm) {
                    ForEach(recipe.tags.prefix(2), id: \.self) { tag in
                        Text(tag)
                            .font(Theme.Typography.micro)
                            .foregroundStyle(Theme.Colors.primary)
                            .padding(.horizontal, Theme.Spacing.sm)
                            .padding(.vertical, 3)
                            .background(Theme.Colors.primaryLight)
                            .clipShape(Capsule())
                    }
                    
                    Spacer()
                    
                    Button {
                    } label: {
                        Image(systemName: "heart")
                            .foregroundStyle(Theme.Colors.textSecondary)
                    }
                }
                
                HStack(spacing: Theme.Spacing.xs) {
                    Image(systemName: "clock")
                        .font(.system(size: 11))
                        .foregroundStyle(Theme.Colors.textSecondary)
                    Text("\(recipe.cookTimeMinutes) mins")
                        .font(Theme.Typography.micro)
                        .foregroundStyle(Theme.Colors.textSecondary)
                    Text("•")
                        .foregroundStyle(Theme.Colors.textTertiary)
                    Image(systemName: "bolt")
                        .font(.system(size: 11))
                        .foregroundStyle(Theme.Colors.textSecondary)
                    Text("320 kcal")
                        .font(Theme.Typography.micro)
                        .foregroundStyle(Theme.Colors.textSecondary)
                }
            }
        }
        .onTapGesture {
            onTap?()
        }
    }
}

// MARK: - Small Card
struct TrendingSmallCard: View {
    let recipe: Recipe
    var onTap: (() -> Void)? = nil
    
    var body: some View {
        HStack(spacing: Theme.Spacing.sm) {
            
            // Image
            ZStack(alignment: .topLeading) {
                AsyncImage(url: URL(string: recipe.imageURL)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Rectangle()
                        .fill(Theme.Colors.surface)
                }
                .frame(width: 80, height: 80)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm))
                
                Text("TRENDING")
                    .font(.system(size: 7, weight: .bold))
                    .foregroundStyle(Theme.Colors.background)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .background(Theme.Colors.tertiary)
                    .clipShape(RoundedRectangle(cornerRadius: 3))
                    .padding(4)
            }
            
            // Info
            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                Text(recipe.name)
                    .font(Theme.Typography.subhead)
                    .foregroundStyle(Theme.Colors.textPrimary)
                    .lineLimit(1)
                Text("by \(recipe.authorUsername)")
                    .font(Theme.Typography.micro)
                    .foregroundStyle(Theme.Colors.textSecondary)
            }
            
            Spacer()
        }
        .padding(Theme.Spacing.sm)
        .background(Theme.Colors.background)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
        .overlay {
            RoundedRectangle(cornerRadius: Theme.Radius.md)
                .stroke(Theme.Colors.divider, lineWidth: 1)
        }
        .onTapGesture {
            onTap?()
        }
    }
}

#Preview {
    NavigationStack {
        TrendingFoodPage()
    }
}
