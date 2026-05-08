//
//  InventoryTab.swift
//
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//

import SwiftUI

struct InventoryTab: View {
    let recipes: [ProfileRecipe]

    var body: some View {
        ProfileRecipeGrid(recipes: recipes)
    }
}
