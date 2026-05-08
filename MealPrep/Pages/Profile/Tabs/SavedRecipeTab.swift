//
//  SavedRecipeTab.swift
//
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//

import SwiftUI

struct SavedRecipeTab: View {
    let recipes: [ProfileRecipe]

    var body: some View {
        ProfileRecipeGrid(recipes: recipes)
    }
}
