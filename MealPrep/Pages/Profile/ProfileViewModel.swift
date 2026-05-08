//
//  ProfileViewModel.swift
//
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//

import SwiftUI

struct ProfileViewModel {
    var selectedTab: ProfileTab = .saved

    let profile = ProfileSummary(
        name: "Alex Thompson",
        recipeCount: "124",
        followerCount: "2.4k",
        followingCount: "850"
    )

    let savedRecipes: [Recipe] = Array(MockRecipes.all.prefix(4))

    let inventoryRecipes: [ProfileRecipe] = [
        ProfileRecipe(title: "Pantry Tomato Soup", imageName: "Lemon_Zest_Linguine"),
        ProfileRecipe(title: "Chickpea Kale Bowl", imageName: "Green_Power_Bowl"),
        ProfileRecipe(title: "Spiced Rice Skillet", imageName: "Honey_Glazed_Salmon"),
        ProfileRecipe(title: "Herb Garden Salad", imageName: "Yoghurt_Berry_Toast")
    ]

    let myRecipes: [ProfileRecipe] = [
        ProfileRecipe(title: "Citrus Chicken Wrap", imageName: "Honey_Glazed_Salmon"),
        ProfileRecipe(title: "Roasted Veggie Pasta", imageName: "Lemon_Zest_Linguine"),
        ProfileRecipe(title: "Apricot Oat Bake", imageName: "Yoghurt_Berry_Toast"),
        ProfileRecipe(title: "Sesame Greens Plate", imageName: "Green_Power_Bowl")
    ]

    let followers: [ProfilePerson] = [
        ProfilePerson(name: "Noah Bennett", handle: "@noah.eats", imageName: "person.crop.circle.fill"),
        ProfilePerson(name: "Ava Collins", handle: "@avabites", imageName: "person.crop.circle.fill"),
        ProfilePerson(name: "Ethan Brooks", handle: "@ethanmealprep", imageName: "person.crop.circle.fill"),
        ProfilePerson(name: "Chloe Davis", handle: "@chloeplates", imageName: "person.crop.circle.fill")
    ]

    let following: [ProfilePerson] = [
        ProfilePerson(name: "Mia Parker", handle: "@miacooks", imageName: "person.crop.circle.fill"),
        ProfilePerson(name: "Jordan Lee", handle: "@prepwithjordan", imageName: "person.crop.circle.fill"),
        ProfilePerson(name: "Taylor Chen", handle: "@taylorplates", imageName: "person.crop.circle.fill"),
        ProfilePerson(name: "Sam Rivera", handle: "@weeknight.sam", imageName: "person.crop.circle.fill")
    ]
}

struct ProfileSummary {
    let name: String
    let recipeCount: String
    let followerCount: String
    let followingCount: String
}

struct ProfileRecipe: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
}

struct ProfileRecipeGrid: View {
    let recipes: [ProfileRecipe]

    private let columns = [
        GridItem(.flexible(), spacing: Theme.Spacing.md),
        GridItem(.flexible(), spacing: Theme.Spacing.md)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: Theme.Spacing.md) {
            ForEach(recipes) { recipe in
                VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                    Image(recipe.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 138)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))

                    Text(recipe.title)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(Theme.Colors.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(.horizontal, Theme.Spacing.md)
        .padding(.top, Theme.Spacing.lg)
    }
}

struct ProfilePerson: Identifiable {
    let id = UUID()
    let name: String
    let handle: String
    let imageName: String
}

enum ProfileTab: CaseIterable, Identifiable {
    case saved
    case inventory
    case myRecipes
    case followers
    case following

    var id: Self { self }

    var title: String {
        switch self {
        case .saved:
            return "Saved"
        case .inventory:
            return "Inventory"
        case .myRecipes:
            return "My Recipes"
        case .followers:
            return "Followers"
        case .following:
            return "Following"
        }
    }
}
