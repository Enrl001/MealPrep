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
    @Published private var selectedWeekStart: Date

    private let calendar: Calendar

    let days = ["M", "T", "W", "T", "F", "S", "S"]
    let times = ["08:00", "10:00", "12:00", "14:00", "16:00", "18:00", "20:00"]

    let fullDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

    let progressTitle = "Weekly Goal Progress"
    let progressText = "85%"
    let progressValue = 0.85

    let dailyCalories = "1,840"
    let mealsPrepped = "12"

    init(calendar: Calendar = .current) {
        self.calendar = calendar
        self.selectedWeekStart = Self.startOfWeek(for: Date(), calendar: calendar)
        self.mealEvents = UserDefaultManager.shared.loadMealEvents(
            forWeekID: Self.weekID(for: selectedWeekStart, calendar: calendar),
            fallbackEvents: Self.defaultEventsForWeek(selectedWeekStart, calendar: calendar)
        )
    }

    var weekLabel: String {
        let currentWeekStart = Self.startOfWeek(for: Date(), calendar: calendar)
        let weekDifference = calendar.dateComponents([.weekOfYear], from: currentWeekStart, to: selectedWeekStart).weekOfYear ?? 0

        switch weekDifference {
        case -1:
            return "Last Week"
        case 0:
            return "This Week"
        case 1:
            return "Next Week"
        case ..<0:
            return "\(abs(weekDifference)) Weeks Ago"
        default:
            return "\(weekDifference) Weeks Ahead"
        }
    }

    var weekRange: String {
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: selectedWeekStart) ?? selectedWeekStart
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMM d")

        return "\(formatter.string(from: selectedWeekStart)) - \(formatter.string(from: endOfWeek))"
    }

    var dates: [String] {
        (0..<7).map { offset in
            let date = calendar.date(byAdding: .day, value: offset, to: selectedWeekStart) ?? selectedWeekStart
            return String(calendar.component(.day, from: date))
        }
    }

    func addMeal(
        recipeName: String,
        mealType: MealType,
        day: String,
        time: String,
        recipe: Recipe? = nil,
        ingredients: [Ingredient] = [],
        missingIngredients: [Ingredient] = []
    ) {
        let meal = MealEvent(
            recipeName: recipeName,
            mealType: mealType,
            day: day,
            time: time,
            recipe: recipe,
            ingredients: ingredients,
            missingIngredients: missingIngredients
        )

        mealEvents.append(meal)
        saveCurrentWeek()
    }

    func moveToPreviousWeek() {
        moveWeek(by: -1)
    }

    func moveToNextWeek() {
        moveWeek(by: 1)
    }

    private func moveWeek(by value: Int) {
        saveCurrentWeek()

        selectedWeekStart = calendar.date(byAdding: .weekOfYear, value: value, to: selectedWeekStart) ?? selectedWeekStart
        mealEvents = UserDefaultManager.shared.loadMealEvents(
            forWeekID: Self.weekID(for: selectedWeekStart, calendar: calendar),
            fallbackEvents: Self.defaultEventsForWeek(selectedWeekStart, calendar: calendar)
        )
    }

    private func saveCurrentWeek() {
        UserDefaultManager.shared.saveMealEvents(mealEvents, forWeekID: Self.weekID(for: selectedWeekStart, calendar: calendar))
    }

    private static func startOfWeek(for date: Date, calendar: Calendar) -> Date {
        calendar.dateInterval(of: .weekOfYear, for: date)?.start ?? calendar.startOfDay(for: date)
    }

    private static func weekID(for date: Date, calendar: Calendar) -> String {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: startOfWeek(for: date, calendar: calendar))
    }

    private static func defaultEventsForWeek(_ weekStart: Date, calendar: Calendar) -> [MealEvent] {
        let currentWeekStart = startOfWeek(for: Date(), calendar: calendar)
        return calendar.isDate(weekStart, inSameDayAs: currentWeekStart) ? UserDefaultManager.defaultMealEvents : []
    }
}
