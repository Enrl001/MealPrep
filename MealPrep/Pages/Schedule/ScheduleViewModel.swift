//
//  ScheduleViewModel.swift
//  
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//
import Combine
import Foundation

final class ScheduleViewModel: ObservableObject {
    @Published var mealEvents: [MealEvent] = []

    let weekLabel = "CURRENT WEEK"
    let weekRange = "Oct 23 - Oct 29"

    let days = ["M", "T", "W", "T", "F", "S", "S"]
    let dates = ["12", "13", "14", "15", "16", "17", "18"]
    let times = ["08:00", "10:00", "12:00", "14:00", "16:00", "18:00", "20:00"]

    let fullDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    let progressTitle = "Weekly Goal Progress"
    let progressText = "85%"
    let progressValue = 0.85

    let dailyCalories = "1,840"
    let mealsPrepped = "12"

    init() {
        mealEvents = UserDefaultManager.shared.loadMealEvents()
    }

    func addMeal(recipeName: String, mealType: MealType, day: String, time: String) {
        let meal = MealEvent(
            recipeName: recipeName,
            mealType: mealType,
            day: day,
            time: time
        )

        mealEvents.append(meal)
        UserDefaultManager.shared.saveMealEvents(mealEvents)
    }
}
