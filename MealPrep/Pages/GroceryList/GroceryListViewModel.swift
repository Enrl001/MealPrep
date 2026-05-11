import Combine
import Foundation
import SwiftUI

struct GroceryItem: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var quantity: String
    var note: String
    var category: GroceryCategory
    var isBought: Bool

    var isChecked: Bool {
        isBought
    }

    init(
        id: UUID = UUID(),
        name: String,
        quantity: String,
        note: String = "",
        category: GroceryCategory,
        isBought: Bool = false
    ) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.note = note
        self.category = category
        self.isBought = isBought
    }
}

enum GroceryCategory: String, CaseIterable, Codable, Hashable {
    case produce = "Produce"
    case dairy = "Dairy"
    case pantry = "Pantry"
    case meat = "Meat"
    case frozen = "Frozen"
    case other = "Other"

    var accentColor: Color {
        switch self {
        case .produce:
            return Theme.Colors.success
        case .dairy:
            return Theme.Colors.Meal.lunch
        case .pantry:
            return Theme.Colors.primary
        case .meat:
            return Theme.Colors.tertiary
        case .frozen:
            return Color.cyan
        case .other:
            return Theme.Colors.textSecondary
        }
    }
}

typealias GrocerySection = (category: GroceryCategory, items: [GroceryItem])

final class GroceryListViewModel: ObservableObject {
    @Published var groceryItems: [GroceryItem] = []
    @Published private var selectedWeekStart: Date

    private let calendar: Calendar

    init(calendar: Calendar = .current) {
        self.calendar = calendar
        self.selectedWeekStart = Self.startOfWeek(for: Date(), calendar: calendar)
        self.groceryItems = UserDefaultManager.shared.loadGroceryItems(
            forWeekID: Self.weekID(for: selectedWeekStart, calendar: calendar),
            fallbackItems: Self.defaultItemsForWeek(selectedWeekStart, calendar: calendar)
        )
    }

    var items: [GroceryItem] {
        groceryItems
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

    var boughtCountText: String {
        let boughtCount = groceryItems.filter { $0.isBought }.count
        return "\(boughtCount) / \(groceryItems.count)"
    }

    var estimatedTotalText: String {
        return "~$84.20"
    }

    var grocerySections: [GrocerySection] {
        GroceryCategory.allCases.compactMap { category in
            let items = groceryItems.filter { $0.category == category }
            guard !items.isEmpty else {
                return nil
            }

            return GrocerySection(category: category, items: items)
        }
    }

    var groupedItems: [GrocerySection] {
        grocerySections
    }

    func toggleBought(item: GroceryItem) {
        guard let index = groceryItems.firstIndex(where: { $0.id == item.id }) else {
            return
        }

        groceryItems[index].isBought.toggle()
        saveCurrentWeek()
    }

    func toggle(_ item: GroceryItem) {
        toggleBought(item: item)
    }

    func reloadCurrentWeek() {
        groceryItems = UserDefaultManager.shared.loadGroceryItems(
            forWeekID: Self.weekID(for: selectedWeekStart, calendar: calendar),
            fallbackItems: Self.defaultItemsForWeek(selectedWeekStart, calendar: calendar)
        )
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
        groceryItems = UserDefaultManager.shared.loadGroceryItems(
            forWeekID: Self.weekID(for: selectedWeekStart, calendar: calendar),
            fallbackItems: Self.defaultItemsForWeek(selectedWeekStart, calendar: calendar)
        )
    }

    private func saveCurrentWeek() {
        UserDefaultManager.shared.saveGroceryItems(groceryItems, forWeekID: Self.weekID(for: selectedWeekStart, calendar: calendar))
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

    private static func defaultItemsForWeek(_ weekStart: Date, calendar: Calendar) -> [GroceryItem] {
        []
    }
}
final class UserDefaultManager {
    static let shared = UserDefaultManager()

    private let groceryItemsKey = "groceryItems"
    private let mealEventsKey = "mealEvents"
    private let defaults: UserDefaults

    private init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func loadGroceryItems() -> [GroceryItem] {
        loadGroceryItems(forWeekID: Self.currentWeekID(), fallbackItems: Self.defaultGroceryItems)
    }

    func loadGroceryItems(forWeekID weekID: String, fallbackItems: [GroceryItem]) -> [GroceryItem] {
        let key = groceryItemsKey(forWeekID: weekID)
        if let weekData = defaults.data(forKey: key) {
            let items = (try? JSONDecoder().decode([GroceryItem].self, from: weekData)) ?? fallbackItems
            if containsOnlyLegacyDefaultGroceryItems(items) {
                defaults.removeObject(forKey: key)
                return fallbackItems
            }
            return items
        }

        if weekID == Self.currentWeekID(), let data = defaults.data(forKey: groceryItemsKey) {
            let items = (try? JSONDecoder().decode([GroceryItem].self, from: data)) ?? fallbackItems
            if containsOnlyLegacyDefaultGroceryItems(items) {
                defaults.removeObject(forKey: groceryItemsKey)
                return fallbackItems
            }

            defaults.set(data, forKey: key)
            return items
        }

        return fallbackItems
    }

    func saveGroceryItems(_ items: [GroceryItem]) {
        saveGroceryItems(items, forWeekID: Self.currentWeekID())
    }

    func saveGroceryItems(_ items: [GroceryItem], forWeekID weekID: String) {
        guard let data = try? JSONEncoder().encode(items) else {
            return
        }

        defaults.set(data, forKey: groceryItemsKey(forWeekID: weekID))
    }

    func addRecipeIngredientsToCurrentGroceryList(
        recipeName: String,
        ingredients: [Ingredient],
        inventory: [InventoryItem]
    ) {
        let weekID = Self.currentWeekID()
        var groceryItems = loadGroceryItems(forWeekID: weekID, fallbackItems: [])

        for ingredient in ingredients {
            let isInInventory = inventory.contains { inventoryItem in
                ingredientMatchesInventory(ingredient.name, inventoryItem.name)
            }

            if let index = groceryItems.firstIndex(where: { ingredientMatchesInventory(ingredient.name, $0.name) }) {
                groceryItems[index].quantity = ingredient.quantity
                groceryItems[index].note = "For \(recipeName)"
                groceryItems[index].isBought = groceryItems[index].isBought || isInInventory
            } else {
                groceryItems.append(
                    GroceryItem(
                        name: ingredient.name,
                        quantity: ingredient.quantity,
                        note: "For \(recipeName)",
                        category: groceryCategory(for: ingredient.name, inventory: inventory),
                        isBought: isInInventory
                    )
                )
            }
        }

        saveGroceryItems(groceryItems, forWeekID: weekID)
    }

    func loadMealEvents() -> [MealEvent] {
        loadMealEvents(forWeekID: Self.currentWeekID(), fallbackEvents: Self.defaultMealEvents)
    }

    func loadMealEvents(forWeekID weekID: String, fallbackEvents: [MealEvent]) -> [MealEvent] {
        let key = mealEventsKey(forWeekID: weekID)
        if let weekData = defaults.data(forKey: key) {
            let events = (try? JSONDecoder().decode([MealEvent].self, from: weekData)) ?? fallbackEvents
            let sanitizedEvents = sanitizedMealEvents(events, forWeekID: weekID)
            if sanitizedEvents.count != events.count {
                saveMealEvents(sanitizedEvents, forWeekID: weekID)
            }
            if sanitizedEvents.isEmpty {
                defaults.removeObject(forKey: key)
                return fallbackEvents
            }
            return sanitizedEvents
        }

        if weekID == Self.currentWeekID(), let data = defaults.data(forKey: mealEventsKey) {
            let events = (try? JSONDecoder().decode([MealEvent].self, from: data)) ?? fallbackEvents
            let sanitizedEvents = sanitizedMealEvents(events, forWeekID: weekID)
            if sanitizedEvents.isEmpty {
                defaults.removeObject(forKey: mealEventsKey)
                return fallbackEvents
            }

            saveMealEvents(sanitizedEvents, forWeekID: weekID)
            return sanitizedEvents
        }

        return fallbackEvents
    }

    func saveMealEvents(_ events: [MealEvent]) {
        saveMealEvents(events, forWeekID: Self.currentWeekID())
    }

    func saveMealEvents(_ events: [MealEvent], forWeekID weekID: String) {
        guard let data = try? JSONEncoder().encode(events) else {
            return
        }

        defaults.set(data, forKey: mealEventsKey(forWeekID: weekID))
    }

    static let defaultGroceryItems: [GroceryItem] = [
        GroceryItem(name: "Baby Spinach", quantity: "1 bag", note: "For salads", category: .produce),
        GroceryItem(name: "Cherry Tomatoes", quantity: "250 g", category: .produce),
        GroceryItem(name: "Eggs", quantity: "12 pcs", category: .dairy),
        GroceryItem(name: "Greek Yogurt", quantity: "500 g", category: .dairy),
        GroceryItem(name: "White Rice", quantity: "1 kg", category: .pantry),
        GroceryItem(name: "Olive Oil", quantity: "500 ml", category: .pantry),
        GroceryItem(name: "Chicken Breast", quantity: "500 g", category: .meat),
        GroceryItem(name: "Frozen Peas", quantity: "500 g", category: .frozen)
    ]

    static let defaultMealEvents: [MealEvent] = []

    private static let legacyDefaultMealEvents: [MealEvent] = [
        MealEvent(recipeName: "Greek Yogurt Bowl", mealType: .breakfast, day: "Mon", time: "08:30 AM"),
        MealEvent(recipeName: "Chicken Rice Bowl", mealType: .lunch, day: "Wed", time: "12:30 PM"),
        MealEvent(recipeName: "Salmon Dinner", mealType: .dinner, day: "Fri", time: "06:30 PM")
    ]

    private func groceryItemsKey(forWeekID weekID: String) -> String {
        "\(groceryItemsKey).\(weekID)"
    }

    private func mealEventsKey(forWeekID weekID: String) -> String {
        "\(mealEventsKey).\(weekID)"
    }

    private func mealEventsCleanupKey(forWeekID weekID: String) -> String {
        "\(mealEventsKey).cleanup.\(weekID)"
    }

    private func sanitizedMealEvents(_ events: [MealEvent], forWeekID weekID: String) -> [MealEvent] {
        let cleanupKey = mealEventsCleanupKey(forWeekID: weekID)
        let shouldRemoveOldPlaceholderEvents = !defaults.bool(forKey: cleanupKey)

        let sanitizedEvents = events.filter { event in
            !isLegacyDefaultMealEvent(event) &&
            !(shouldRemoveOldPlaceholderEvents && event.recipe == nil && event.ingredients.isEmpty)
        }

        defaults.set(true, forKey: cleanupKey)
        return sanitizedEvents
    }

    private func removingLegacyDefaultMealEvents(from events: [MealEvent]) -> [MealEvent] {
        events.filter { event in
            !isLegacyDefaultMealEvent(event)
        }
    }

    private func isLegacyDefaultMealEvent(_ event: MealEvent) -> Bool {
        Self.legacyDefaultMealEvents.contains { legacyEvent in
            event.recipeName == legacyEvent.recipeName &&
            event.mealType == legacyEvent.mealType &&
            event.day == legacyEvent.day &&
            event.time == legacyEvent.time &&
            event.recipe == nil &&
            event.ingredients.isEmpty
        }
    }

    private func containsOnlyLegacyDefaultGroceryItems(_ items: [GroceryItem]) -> Bool {
        guard items.count == Self.defaultGroceryItems.count else {
            return false
        }

        return items.allSatisfy { item in
            Self.defaultGroceryItems.contains { defaultItem in
                item.name == defaultItem.name &&
                item.quantity == defaultItem.quantity &&
                item.category == defaultItem.category
            }
        }
    }

    private func groceryCategory(for ingredientName: String, inventory: [InventoryItem]) -> GroceryCategory {
        if let inventoryItem = inventory.first(where: { ingredientMatchesInventory(ingredientName, $0.name) }) {
            return GroceryCategory(inventoryCategory: inventoryItem.category)
        }

        if let defaultItem = DefaultInventoryItems.all.first(where: { ingredientMatchesInventory(ingredientName, $0.name) }) {
            return GroceryCategory(inventoryCategory: defaultItem.category)
        }

        return .other
    }

    private func ingredientMatchesInventory(_ ingredientName: String, _ inventoryName: String) -> Bool {
        let ingredient = normalizedIngredientName(ingredientName)
        let inventory = normalizedIngredientName(inventoryName)

        return ingredient == inventory || ingredient.contains(inventory) || inventory.contains(ingredient)
    }

    private func normalizedIngredientName(_ name: String) -> String {
        name
            .lowercased()
            .replacingOccurrences(of: "-", with: " ")
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
            .map { word in
                word.hasSuffix("s") ? String(word.dropLast()) : word
            }
            .joined(separator: " ")
    }

    private static func currentWeekID(calendar: Calendar = .current) -> String {
        let weekStart = calendar.dateInterval(of: .weekOfYear, for: Date())?.start ?? calendar.startOfDay(for: Date())
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: weekStart)
    }
}

private extension GroceryCategory {
    init(inventoryCategory: InventoryCategory) {
        switch inventoryCategory {
        case .produce:
            self = .produce
        case .dairy:
            self = .dairy
        case .pantry:
            self = .pantry
        case .meat:
            self = .meat
        case .frozen:
            self = .frozen
        }
    }
}
