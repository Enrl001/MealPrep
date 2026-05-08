//
//  DefaultInventoryItems.swift
//  MealPrep
//
//  Created by S M Rakib Chowdhury on 8/5/26.
//

import Foundation

struct DefaultInventoryItems {

    static let all: [InventoryItem] = produce + dairy + pantry + meat + frozen

    // MARK: Produce

    static let produce: [InventoryItem] = [
        InventoryItem(name: "Garlic",           quantity: 1,   unit: "bulb",   category: .produce),
        InventoryItem(name: "Yellow Onion",      quantity: 3,   unit: "pcs",    category: .produce),
        InventoryItem(name: "Baby Spinach",      quantity: 1,   unit: "bag",    category: .produce),
        InventoryItem(name: "Cherry Tomatoes",   quantity: 250, unit: "g",      category: .produce),
        InventoryItem(name: "Banana",            quantity: 4,   unit: "pcs",    category: .produce),
        InventoryItem(name: "Lemon",             quantity: 2,   unit: "pcs",    category: .produce),
        InventoryItem(name: "Broccoli",          quantity: 1,   unit: "head",   category: .produce),
        InventoryItem(name: "Carrot",            quantity: 3,   unit: "pcs",    category: .produce),
    ]

    // MARK: Dairy

    static let dairy: [InventoryItem] = [
        InventoryItem(name: "Eggs",              quantity: 12,  unit: "pcs",    category: .dairy),
        InventoryItem(name: "Whole Milk",        quantity: 1,   unit: "L",      category: .dairy),
        InventoryItem(name: "Greek Yogurt",      quantity: 500, unit: "g",      category: .dairy),
        InventoryItem(name: "Cheddar Cheese",    quantity: 200, unit: "g",      category: .dairy),
        InventoryItem(name: "Unsalted Butter",   quantity: 250, unit: "g",      category: .dairy),
        InventoryItem(name: "Almond Milk",       quantity: 1,   unit: "carton", category: .dairy),
    ]

    // MARK: Pantry

    static let pantry: [InventoryItem] = [
        InventoryItem(name: "White Rice",        quantity: 1,   unit: "kg",     category: .pantry),
        InventoryItem(name: "Pasta",             quantity: 500, unit: "g",      category: .pantry),
        InventoryItem(name: "Olive Oil",         quantity: 500, unit: "ml",     category: .pantry),
        InventoryItem(name: "Soy Sauce",         quantity: 200, unit: "ml",     category: .pantry),
        InventoryItem(name: "Canned Chickpeas",  quantity: 400, unit: "g",      category: .pantry),
        InventoryItem(name: "Canned Tomatoes",   quantity: 400, unit: "g",      category: .pantry),
        InventoryItem(name: "Chicken Stock",     quantity: 500, unit: "ml",     category: .pantry),
        InventoryItem(name: "Rolled Oats",       quantity: 500, unit: "g",      category: .pantry),
        InventoryItem(name: "Chia Seeds",        quantity: 200, unit: "g",      category: .pantry),
        InventoryItem(name: "Honey",             quantity: 340, unit: "g",      category: .pantry),
        InventoryItem(name: "Salt",              quantity: 500, unit: "g",      category: .pantry),
        InventoryItem(name: "Black Pepper",      quantity: 50,  unit: "g",      category: .pantry),
        InventoryItem(name: "Cumin",             quantity: 30,  unit: "g",      category: .pantry),
        InventoryItem(name: "Paprika",           quantity: 30,  unit: "g",      category: .pantry),
        InventoryItem(name: "Quinoa",            quantity: 500, unit: "g",      category: .pantry),
        InventoryItem(name: "Bread",             quantity: 1,   unit: "loaf",   category: .pantry),
        InventoryItem(name: "Peanut Butter",     quantity: 340, unit: "g",      category: .pantry),
    ]

    // MARK: Meat

    static let meat: [InventoryItem] = [
        InventoryItem(name: "Chicken Breast",    quantity: 500, unit: "g",      category: .meat),
        InventoryItem(name: "Ground Beef",       quantity: 400, unit: "g",      category: .meat),
        InventoryItem(name: "Salmon Fillet",     quantity: 300, unit: "g",      category: .meat),
    ]

    // MARK: Frozen

    static let frozen: [InventoryItem] = [
        InventoryItem(name: "Frozen Peas",       quantity: 500, unit: "g",      category: .frozen),
        InventoryItem(name: "Frozen Corn",       quantity: 400, unit: "g",      category: .frozen),
        InventoryItem(name: "Frozen Edamame",    quantity: 300, unit: "g",      category: .frozen),
    ]
}
