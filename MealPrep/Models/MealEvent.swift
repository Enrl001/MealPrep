import Foundation
import SwiftUI

struct MealEvent: Identifiable, Codable, Equatable {
    let id: UUID
    let recipeName: String
    let mealType: MealType
    let day: String
    let time: String
    let recipe: Recipe?
    let ingredients: [Ingredient]
    let missingIngredients: [Ingredient]

    private enum CodingKeys: String, CodingKey {
        case id
        case recipeName
        case mealType
        case day
        case time
        case recipe
        case ingredients
        case missingIngredients
    }

    init(
        id: UUID = UUID(),
        recipeName: String,
        mealType: MealType,
        day: String,
        time: String,
        recipe: Recipe? = nil,
        ingredients: [Ingredient] = [],
        missingIngredients: [Ingredient] = []
    ) {
        self.id = id
        self.recipeName = recipeName
        self.mealType = mealType
        self.day = day
        self.time = time
        self.recipe = recipe
        self.ingredients = ingredients
        self.missingIngredients = missingIngredients
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(UUID.self, forKey: .id)
        recipeName = try container.decode(String.self, forKey: .recipeName)
        mealType = try container.decode(MealType.self, forKey: .mealType)
        day = try container.decode(String.self, forKey: .day)
        time = try container.decode(String.self, forKey: .time)
        recipe = try container.decodeIfPresent(Recipe.self, forKey: .recipe)
        ingredients = try container.decodeIfPresent([Ingredient].self, forKey: .ingredients) ?? []
        missingIngredients = try container.decodeIfPresent([Ingredient].self, forKey: .missingIngredients) ?? []
    }
}

extension MealType: Identifiable, Codable {
    var id: String {
        rawValue
    }

    var color: Color {
        switch self {
        case .breakfast:
            return Theme.Colors.Meal.breakfast
        case .lunch:
            return Theme.Colors.Meal.lunch
        case .dinner:
            return Theme.Colors.Meal.dinner
        case .snack:
            return Theme.Colors.Meal.snack
        }
    }

    var lightColor: Color {
        color.opacity(0.16)
    }
}
