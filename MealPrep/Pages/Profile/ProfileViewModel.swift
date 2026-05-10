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
