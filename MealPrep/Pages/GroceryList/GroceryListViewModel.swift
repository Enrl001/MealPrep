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

    let weekLabel = "CURRENT WEEK"
    let weekRange = "Oct 23 - Oct 29"

    init() {
        groceryItems = UserDefaultManager.shared.loadGroceryItems()
    }

    var items: [GroceryItem] {
        groceryItems
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
        UserDefaultManager.shared.saveGroceryItems(groceryItems)
    }

    func toggle(_ item: GroceryItem) {
        toggleBought(item: item)
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
        guard let data = defaults.data(forKey: groceryItemsKey) else {
            return Self.defaultGroceryItems
        }

        do {
            return try JSONDecoder().decode([GroceryItem].self, from: data)
        } catch {
            return Self.defaultGroceryItems
        }
    }

    func saveGroceryItems(_ items: [GroceryItem]) {
        guard let data = try? JSONEncoder().encode(items) else {
            return
        }

        defaults.set(data, forKey: groceryItemsKey)
    }

    func loadMealEvents() -> [MealEvent] {
        guard let data = defaults.data(forKey: mealEventsKey) else {
            return Self.defaultMealEvents
        }

        do {
            return try JSONDecoder().decode([MealEvent].self, from: data)
        } catch {
            return Self.defaultMealEvents
        }
    }

    func saveMealEvents(_ events: [MealEvent]) {
        guard let data = try? JSONEncoder().encode(events) else {
            return
        }

        defaults.set(data, forKey: mealEventsKey)
    }

    private static let defaultGroceryItems: [GroceryItem] = [
        GroceryItem(name: "Baby Spinach", quantity: "1 bag", note: "For salads", category: .produce),
        GroceryItem(name: "Cherry Tomatoes", quantity: "250 g", category: .produce),
        GroceryItem(name: "Eggs", quantity: "12 pcs", category: .dairy),
        GroceryItem(name: "Greek Yogurt", quantity: "500 g", category: .dairy),
        GroceryItem(name: "White Rice", quantity: "1 kg", category: .pantry),
        GroceryItem(name: "Olive Oil", quantity: "500 ml", category: .pantry),
        GroceryItem(name: "Chicken Breast", quantity: "500 g", category: .meat),
        GroceryItem(name: "Frozen Peas", quantity: "500 g", category: .frozen)
    ]

    private static let defaultMealEvents: [MealEvent] = [
        MealEvent(recipeName: "Greek Yogurt Bowl", mealType: .breakfast, day: "Mon", time: "08:30 AM"),
        MealEvent(recipeName: "Chicken Rice Bowl", mealType: .lunch, day: "Wed", time: "12:30 PM"),
        MealEvent(recipeName: "Salmon Dinner", mealType: .dinner, day: "Fri", time: "06:30 PM")
    ]
}

