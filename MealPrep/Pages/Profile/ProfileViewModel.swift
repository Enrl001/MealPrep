//
//  ProfileViewModel.swift
//
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//

import SwiftUI

struct ProfileViewModel {
    var selectedTab: ProfileTab = .saved
    
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
