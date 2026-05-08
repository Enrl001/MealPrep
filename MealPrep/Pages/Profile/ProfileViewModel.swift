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

    let savedRecipes: [ProfileRecipe] = [
        ProfileRecipe(title: "Honey Glazed Salmon", imageName: "Honey_Glazed_Salmon"),
        ProfileRecipe(title: "Lemon Zest Linguine", imageName: "Lemon_Zest_Linguine"),
        ProfileRecipe(title: "Green Power Bowl", imageName: "Green_Power_Bowl"),
        ProfileRecipe(title: "Berry Yogurt Toast", imageName: "Yoghurt_Berry_Toast")
    ]

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

    var background: LinearGradient {
        let gradients: [LinearGradient] = [
            LinearGradient(colors: [Color(hex: "#F5A25D"), Color(hex: "#E36D44")], startPoint: .topLeading, endPoint: .bottomTrailing),
            LinearGradient(colors: [Color(hex: "#86847E"), Color(hex: "#2F3338")], startPoint: .topLeading, endPoint: .bottomTrailing),
            LinearGradient(colors: [Color(hex: "#9BB17D"), Color(hex: "#4C6B43")], startPoint: .topLeading, endPoint: .bottomTrailing),
            LinearGradient(colors: [Color(hex: "#E6B67A"), Color(hex: "#C98247")], startPoint: .topLeading, endPoint: .bottomTrailing),
            LinearGradient(colors: [Color(hex: "#E58B73"), Color(hex: "#AE4337")], startPoint: .topLeading, endPoint: .bottomTrailing),
            LinearGradient(colors: [Color(hex: "#D6C06B"), Color(hex: "#80742B")], startPoint: .topLeading, endPoint: .bottomTrailing)
        ]

        return gradients[abs(title.hashValue) % gradients.count]
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
