//
//  InventoryTab.swift
//
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//

import SwiftUI

struct InventoryTab: View {
//    let recipes: [ProfileRecipe]

    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: Theme.Spacing.md),
                GridItem(.flexible(), spacing: Theme.Spacing.md)
            ],
            spacing: Theme.Spacing.md
        ) {
//            ForEach(recipes) { recipe in
//                VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
//                    Image(recipe.imageName)
//                        .resizable()
//                        .scaledToFill()
//                        .frame(height: 140)
//                        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
//                        .clipped()
//
//                    Text(recipe.title)
//                        .font(.system(size: 15, weight: .medium))
//                        .foregroundStyle(Theme.Colors.textPrimary)
//                        .fixedSize(horizontal: false, vertical: true)
//                }
//            }
        }
        .padding(.horizontal, Theme.Spacing.md)
        .padding(.top, Theme.Spacing.lg)
    }
}
