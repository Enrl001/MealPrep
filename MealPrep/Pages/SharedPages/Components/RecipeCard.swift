//
//  RecipeCard.swift
//  
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//

import SwiftUI

struct RecipeCard: View {
    let recipe: Recipe
    
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: - Image (top half)
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
                    }
            }
            .frame(width: 160, height: 110)
            .clipped()
            
            // MARK: - Info (bottom half)
            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                
                // Meal type tag
                Text(recipe.mealType.uppercased())
                    .font(Theme.Typography.micro)
                    .foregroundStyle(Theme.Colors.primary)
                    .padding(.horizontal, Theme.Spacing.xs)
                    .padding(.vertical, 2)
                    .background(Theme.Colors.primaryLight)
                    .clipShape(Capsule())
                
                // Recipe name
                Text(recipe.name)
                    .font(Theme.Typography.subhead)
                    .foregroundStyle(Theme.Colors.textPrimary)
                    .lineLimit(2)
                
                // Rating + cook time
                HStack(spacing: Theme.Spacing.xs) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(Theme.Colors.primary)
                        .font(.system(size: 11))
                    Text("\(recipe.rating, specifier: "%.1f") (\(recipe.reviewCount))")
                        .font(Theme.Typography.micro)
                        .foregroundStyle(Theme.Colors.textSecondary)
                    
                    Spacer()
                    
                    // Cook time badge
                    Text("\(recipe.cookTimeMinutes) MIN")
                        .font(Theme.Typography.micro)
                        .foregroundStyle(Theme.Colors.textSecondary)
                }
            }
            .padding(Theme.Spacing.sm)
            .frame(width: 160, height: 110, alignment: .topLeading)
            .background(Theme.Colors.background)
        }
        .frame(width: 160, height: 220)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
        .overlay {
            RoundedRectangle(cornerRadius: Theme.Radius.md)
                .stroke(Theme.Colors.divider, lineWidth: 1)
        }
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.spring(duration: 0.2), value: isPressed)
        .onLongPressGesture(minimumDuration: .infinity,
                            pressing: { isPressed = $0 },
                            perform: {})
    }
}

#Preview {
    RecipeCard(recipe: RecipeMockData.recipes[0])
        .padding()
}
