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
    
    var likedRecipeIDs: Set<UUID> = []
    var followedBloggerIDs: Set<UUID> = []
    
    // Liked Recipes
    func toggleLike(for recipe: Recipe) {
        if likedRecipeIDs.contains(recipe.id) {
            likedRecipeIDs.remove(recipe.id)
        } else {
            likedRecipeIDs.insert(recipe.id)
        }
    }
    
    func isLiked(_ recipe: Recipe) -> Bool {
        likedRecipeIDs.contains(recipe.id)
    }
    
    var likedRecipes: [Recipe] {
        MockRecipes.all.filter { likedRecipeIDs.contains($0.id) }
    }
    
    // Followed Bloggers
    func toggleFollow(for blogger: Blogger) {
        if followedBloggerIDs.contains(blogger.id) {
            followedBloggerIDs.remove(blogger.id)
        } else {
            followedBloggerIDs.insert(blogger.id)
        }
    }
    
    func isFollowing(_ blogger: Blogger) -> Bool {
        followedBloggerIDs.contains(blogger.id)
    }
    
    var followedBloggers: [Blogger] {
        BloggerMockData.bloggers.filter { followedBloggerIDs.contains($0.id) }
    }
}
