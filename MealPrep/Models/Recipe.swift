//
//  Recipe.swift
//  MealPrep
//
//  Created by Hline Nadi Khant on 8/5/2026.
//

import Foundation

struct Recipe: Identifiable {
    let id: UUID
    let name: String
    let imageURL: String
    let cookTimeMinutes: Int
    let cuisine: String
    let mealType: String
    let rating: Double
    let reviewCount: Int
}

