//
//  Recipe.swift
//  MealPrep
//
//  Created by Hline Nadi Khant on 8/5/2026.
//

import Foundation

enum MealType: String, CaseIterable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case snack = "Snack"
}

struct Recipe: Identifiable, Codable {
    let id: UUID
    let name: String
    let imageURL: String
    let cookTimeMinutes: Int
    let cuisine: String
    let mealType: String
    let rating: Double
    let reviewCount: Int
    let servings: Int
    let ingredients: [Ingredient]
    let instructions: [RecipeStep]
    let authorUsername: String
    let isPublic: Bool
    let isTrending: Bool
    let tags: [String]

    var title: String { name }
    init(
        id: UUID,
        name: String,
        imageURL: String,
        cookTimeMinutes: Int,
        cuisine: String,
        mealType: String,
        rating: Double,
        reviewCount: Int,
        servings: Int = 1,
        ingredients: [Ingredient] = [],
        instructions: [RecipeStep] = [],
        authorUsername: String = "",
        isPublic: Bool = true,
        isTrending: Bool = false,
        tags: [String] = []
    ) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.cookTimeMinutes = cookTimeMinutes
        self.cuisine = cuisine
        self.mealType = mealType
        self.rating = rating
        self.reviewCount = reviewCount
        self.servings = servings
        self.ingredients = ingredients
        self.instructions = instructions
        self.authorUsername = authorUsername
        self.isPublic = isPublic
        self.isTrending = isTrending
        self.tags = tags
    }

    init(
        id: UUID,
        name: String,
        imageURL: String,
        cuisine: String,
        mealType: MealType,
        cookingTimeMinutes: Int,
        reviewCount: Int,
        servings: Int,
        rating: Double,
        ingredients: [Ingredient],
        instructions: [RecipeStep],
        authorUsername: String,
        isPublic: Bool,
        isTrending: Bool,
        tags: [String]
    ) {
        self.init(
            id: id,
            name: name,
            imageURL: imageURL,
            cookTimeMinutes: cookingTimeMinutes,
            cuisine: cuisine,
            mealType: mealType.rawValue,
            rating: rating,
            reviewCount: reviewCount,
            servings: servings,
            ingredients: ingredients,
            instructions: instructions,
            authorUsername: authorUsername,
            isPublic: isPublic,
            isTrending: isTrending,
            tags: tags
        )
    }

    init(
        id: UUID,
        title: String,
        imageURL: String,
        cuisine: String,
        mealType: MealType,
        prepTime: Int,
        calories: Int,
        servings: Int,
        ingredients: [Ingredient],
        instructions: [RecipeStep],
        authorUsername: String,
        isPublic: Bool,
        isTrending: Bool,
        tags: [String]
    ) {
        self.init(
            id: id,
            name: title,
            imageURL: imageURL,
            cookTimeMinutes: prepTime,
            cuisine: cuisine,
            mealType: mealType.rawValue,
            rating: 0,
            reviewCount: 0,
            servings: servings,
            ingredients: ingredients,
            instructions: instructions,
            authorUsername: authorUsername,
            isPublic: isPublic,
            isTrending: isTrending,
            tags: tags
        )
    }
}
struct Ingredient: Hashable, Codable {
    let name: String
    let quantity: String
}

struct RecipeStep: Hashable, Codable {
    let title: String
    let description: String
}

func saveRecipes(for userId: String, recipes: [Recipe]) {
    let key = "recipes_\(userId)"

    do {
        let data = try JSONEncoder().encode(recipes)
        UserDefaults.standard.set(data, forKey: key)
    } catch {
        print(error)
    }
}

func loadRecipes(for userId: String) -> [Recipe] {
    let key = "recipes_\(userId)"

    guard let data = UserDefaults.standard.data(forKey: key) else {
        return []
    }

    return (try? JSONDecoder().decode([Recipe].self, from: data)) ?? []
}
