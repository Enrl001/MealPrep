import Foundation
import SwiftUI

struct MealEvent: Identifiable, Codable, Equatable {
    let id: UUID
    let recipeName: String
    let mealType: MealType
    let day: String
    let time: String

    init(
        id: UUID = UUID(),
        recipeName: String,
        mealType: MealType,
        day: String,
        time: String
    ) {
        self.id = id
        self.recipeName = recipeName
        self.mealType = mealType
        self.day = day
        self.time = time
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
