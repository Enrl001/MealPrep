//
//  InventoryItem.swift
//  MealPrep
//
//  Created by S M Rakib Chowdhury on 8/5/26.
//

import Foundation
 
enum InventoryCategory: String, CaseIterable, Identifiable, Codable {
    case produce = "Produce"
    case dairy = "Dairy"
    case pantry = "Pantry"
    case meat = "Meat"
    case frozen = "Frozen"

    var id: String { rawValue }
}

struct InventoryItem: Identifiable, Hashable, Codable {
    var id: UUID
    var name: String
    var quantity: Double
    var unit: String
    var category: InventoryCategory
 
    init(id: UUID = UUID(), name: String, quantity: Double, unit: String, category: InventoryCategory) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.unit = unit
        self.category = category
    }
}
 
