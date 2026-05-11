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
    private let followedBloggersKey = "followedBloggers"

    var likedRecipeIDs: Set<UUID> = []
    var followedBloggerIDs: Set<UUID> = []
    private var storedLikedRecipes: [Recipe] = []
    private var storedFollowedBloggers: [Blogger] = []

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
        if isFollowing(blogger) {
            followedBloggerIDs.remove(blogger.id)
            storedFollowedBloggers.removeAll { savedBlogger in
                savedBlogger.id == blogger.id || savedBlogger.name == blogger.name
            }
        } else {
            followedBloggerIDs.insert(blogger.id)
            storedFollowedBloggers.insert(blogger, at: 0)
        }

        saveFollowedBloggers()
    }

    func isFollowing(_ blogger: Blogger) -> Bool {
        followedBloggerIDs.contains(blogger.id) || storedFollowedBloggers.contains { $0.name == blogger.name }
    }

    var followedBloggers: [Blogger] {
        storedFollowedBloggers
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
        do {
            let data = try JSONEncoder().encode(storedFollowedBloggers)
            UserDefaults.standard.set(data, forKey: followedBloggersKey)
        } catch {
            print("Failed to save followed bloggers:", error)
        }
    }

    private func loadFollowedBloggers() {
        guard let data = UserDefaults.standard.data(forKey: followedBloggersKey) else { return }

        do {
            storedFollowedBloggers = try JSONDecoder().decode([Blogger].self, from: data)
            followedBloggerIDs = Set(storedFollowedBloggers.map(\.id))
        } catch {
            print("Failed to load followed bloggers:", error)
        }
    }
}
