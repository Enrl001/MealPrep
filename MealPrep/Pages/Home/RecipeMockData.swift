//
//  RecipeMockData.swift
//  MealPrep
//
//  Created by Hline Nadi Khant on 8/5/2026.
//

import Foundation

struct RecipeMockData {
    static let recipes: [Recipe] = [
        Recipe(id: UUID(),
               name: "Creamy Basil Pesto Linguine",
               imageURL: "",
               cookTimeMinutes: 15,
               cuisine: "Italian",
               mealType: "Lunch",
               rating: 4.9,
               reviewCount: 1200),
        Recipe(id: UUID(),
               name: "Rainbow Quinoa Bowl",
               imageURL: "",
               cookTimeMinutes: 20,
               cuisine: "Healthy",
               mealType: "Lunch",
               rating: 4.7,
               reviewCount: 850)
    ]
}
