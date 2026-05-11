//
//  UserLibrary.swift
//  MealPrep
//
//  Created by Hline Nadi Khant on 11/5/2026.
//

import SwiftUI

@Observable
class UserLibrary {
    static let shared = UserLibrary()

    private let likedRecipesKey = "likedRecipes"
    private let followedBloggersKey = "followedBloggerIDs"

    var likedRecipeIDs: Set<UUID> = []
    var followedBloggerIDs: Set<UUID> = []
    private var storedLikedRecipes: [Recipe] = []

    init() {
        loadLikedRecipes()
        loadFollowedBloggers()
    }

    // Liked Recipes
    func toggleLike(for recipe: Recipe) {
        if isLiked(recipe) {
            likedRecipeIDs.remove(recipe.id)
            storedLikedRecipes.removeAll { savedRecipe in
                savedRecipe.id == recipe.id || savedRecipe.name == recipe.name
            }
        } else {
            likedRecipeIDs.insert(recipe.id)
            storedLikedRecipes.insert(recipe, at: 0)
        }

        saveLikedRecipes()
    }

    func isLiked(_ recipe: Recipe) -> Bool {
        likedRecipeIDs.contains(recipe.id) || storedLikedRecipes.contains { $0.name == recipe.name }
    }

    var likedRecipes: [Recipe] {
        storedLikedRecipes
    }

    // Followed Bloggers
    func toggleFollow(for blogger: Blogger) {
        if followedBloggerIDs.contains(blogger.id) {
            followedBloggerIDs.remove(blogger.id)
        } else {
            followedBloggerIDs.insert(blogger.id)
        }

        saveFollowedBloggers()
    }

    func isFollowing(_ blogger: Blogger) -> Bool {
        followedBloggerIDs.contains(blogger.id)
    }

    var followedBloggers: [Blogger] {
        BloggerMockData.bloggers.filter { followedBloggerIDs.contains($0.id) }
    }

    private func saveLikedRecipes() {
        do {
            let data = try JSONEncoder().encode(storedLikedRecipes)
            UserDefaults.standard.set(data, forKey: likedRecipesKey)
        } catch {
            print("Failed to save liked recipes:", error)
        }
    }

    private func loadLikedRecipes() {
        guard let data = UserDefaults.standard.data(forKey: likedRecipesKey) else { return }

        do {
            storedLikedRecipes = try JSONDecoder().decode([Recipe].self, from: data)
            likedRecipeIDs = Set(storedLikedRecipes.map(\.id))
        } catch {
            print("Failed to load liked recipes:", error)
        }
    }

    private func saveFollowedBloggers() {
        let ids = followedBloggerIDs.map(\.uuidString)
        UserDefaults.standard.set(ids, forKey: followedBloggersKey)
    }

    private func loadFollowedBloggers() {
        let ids = UserDefaults.standard.stringArray(forKey: followedBloggersKey) ?? []
        followedBloggerIDs = Set(ids.compactMap(UUID.init(uuidString:)))
    }
}
