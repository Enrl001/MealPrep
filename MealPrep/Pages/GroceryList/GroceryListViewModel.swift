//
//  GroceryListViewModel.swift
//
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//

import Observation
import SwiftUI

enum GroceryCategory: String, CaseIterable, Identifiable {
    case produce = "Produce"
    case protein = "Protein"
    case dairy = "Dairy"
    case grains = "Grains"
    case pantry = "Pantry"
    case frozen = "Frozen"
    case snacks = "Snacks"
    case beverages = "Beverages"
    case other = "Other"

    var id: String { rawValue }

    var accentColor: Color {
        switch self {
        case .produce:
            return .green
        case .protein:
            return .red
        case .dairy:
            return .blue
        case .grains:
            return .orange
        case .pantry:
            return .brown
        case .frozen:
            return .cyan
        case .snacks:
            return .pink
        case .beverages:
            return .teal
        case .other:
            return .gray
        }
    }

    var badgeColor: Color {
        accentColor.opacity(0.14)
    }
}

struct GroceryItem: Identifiable, Equatable {
    let id: UUID
    let name: String
    let quantity: String
    let category: GroceryCategory
    var isChecked: Bool

    init(
        id: UUID = UUID(),
        name: String,
        quantity: String = "",
        category: GroceryCategory,
        isChecked: Bool = false
    ) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.category = category
        self.isChecked = isChecked
    }
}

@Observable
@MainActor
final class GroceryListViewModel {
    var items: [GroceryItem] = []

    var groupedItems: [(category: GroceryCategory, items: [GroceryItem])] {
        GroceryCategory.allCases.compactMap { category in
            let categoryItems = items.filter { $0.category == category }
            guard !categoryItems.isEmpty else { return nil }
            return (category, categoryItems)
        }
    }

    func toggle(_ item: GroceryItem) {
        guard let index = items.firstIndex(of: item) else { return }
        items[index].isChecked.toggle()
    }

    func deleteItems(at offsets: IndexSet, in category: GroceryCategory) {
        let idsToDelete = offsets
            .compactMap { groupedItems.first(where: { $0.category == category })?.items[$0].id }
        items.removeAll { idsToDelete.contains($0.id) }
    }
}
