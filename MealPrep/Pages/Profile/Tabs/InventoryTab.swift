//
//  InventoryTab.swift
//
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//

import SwiftUI

struct InventoryTab: View {
    @EnvironmentObject private var authViewModel: AuthViewModel

    @State private var searchText = ""
    @State private var selectedFilter: InventoryFilter = .all
    @State private var inventory: [InventoryItem] = []

    private let sectionOrder: [InventoryCategory] = [.produce, .dairy, .pantry, .meat, .frozen]

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            searchField
            filterChips

            if shouldShowSuggestions {
                suggestionPanel
            }

            inventorySections
        }
        .padding(.horizontal, Theme.Spacing.md)
        .padding(.top, Theme.Spacing.md)
        .onAppear(perform: loadInventoryForCurrentUser)
        .onChange(of: authViewModel.currentUser?.id) { _, _ in
            loadInventoryForCurrentUser()
        }
    }

    private var searchField: some View {
        HStack(spacing: Theme.Spacing.sm) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: Theme.IconSize.sm, weight: .semibold))
                .foregroundStyle(Theme.Colors.textSecondary)

            TextField("Search or add ingredients", text: $searchText)
                .font(Theme.Typography.body)
                .foregroundStyle(Theme.Colors.textPrimary)
                .textInputAutocapitalization(.words)

            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: Theme.IconSize.sm, weight: .semibold))
                        .foregroundStyle(Theme.Colors.textTertiary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, Theme.Spacing.md)
        .frame(height: 50)
        .background(Theme.Colors.background)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.md)
                .stroke(searchText.isEmpty ? Theme.Colors.divider : Theme.Colors.primary.opacity(0.8), lineWidth: 1)
        )
    }

    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Theme.Spacing.sm) {
                ForEach(InventoryFilter.allCases) { filter in
                    Button {
                        selectedFilter = filter
                    } label: {
                        Text(filter.title)
                            .font(Theme.Typography.caption.weight(.semibold))
                            .foregroundStyle(selectedFilter == filter ? .white : Theme.Colors.textPrimary)
                            .frame(minWidth: 72)
                            .padding(.vertical, Theme.Spacing.sm)
                            .padding(.horizontal, Theme.Spacing.sm)
                            .background(selectedFilter == filter ? Theme.Colors.primary : Theme.Colors.background)
                            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm))
                            .overlay(
                                RoundedRectangle(cornerRadius: Theme.Radius.sm)
                                    .stroke(selectedFilter == filter ? Theme.Colors.primary : Theme.Colors.divider)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    @ViewBuilder
    private var suggestionPanel: some View {
        let suggestions = matchingSuggestions

        VStack(spacing: 0) {
            if suggestions.isEmpty {
                addCustomSuggestion
            } else {
                ForEach(Array(suggestions.prefix(3).enumerated()), id: \.element.id) { index, item in
                    suggestionRow(item)

                    if index < min(suggestions.count, 3) - 1 {
                        Divider()
                            .padding(.leading, 56)
                    }
                }

                Divider()
                    .padding(.leading, 56)

                addCustomSuggestion
            }
        }
        .background(Theme.Colors.background)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.md)
                .stroke(Theme.Colors.divider)
        )
    }

    private var addCustomSuggestion: some View {
        Button {
            addCustomItem()
        } label: {
            HStack(spacing: Theme.Spacing.sm) {
                Text("\"\(searchText.trimmingCharacters(in: .whitespacesAndNewlines))\"")
                    .font(Theme.Typography.caption.weight(.semibold))
                    .foregroundStyle(Theme.Colors.textPrimary)
                    .lineLimit(1)

                Spacer()

                Image(systemName: "plus")
                    .font(.system(size: Theme.IconSize.sm, weight: .semibold))
                    .foregroundStyle(Theme.Colors.primary)
            }
            .padding(.horizontal, Theme.Spacing.md)
            .padding(.vertical, Theme.Spacing.sm)
        }
        .buttonStyle(.plain)
    }

    private func suggestionRow(_ item: InventoryItem) -> some View {
        Button {
            addItem(item)
        } label: {
            HStack(spacing: Theme.Spacing.sm) {
                categoryIcon(item.category, size: 36)

                VStack(alignment: .leading, spacing: 2) {
                    Text(item.name)
                        .font(Theme.Typography.caption.weight(.semibold))
                        .foregroundStyle(Theme.Colors.textPrimary)
                        .lineLimit(1)

                    Text(item.category.rawValue)
                        .font(Theme.Typography.micro)
                        .foregroundStyle(Theme.Colors.textSecondary)
                }

                Spacer()

                Image(systemName: "plus")
                    .font(.system(size: Theme.IconSize.sm, weight: .semibold))
                    .foregroundStyle(Theme.Colors.primary)
            }
            .padding(.horizontal, Theme.Spacing.md)
            .padding(.vertical, Theme.Spacing.sm)
        }
        .buttonStyle(.plain)
    }

    private var inventorySections: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
            ForEach(sectionOrder, id: \.self) { category in
                let items = filteredItems(for: category)
                if !items.isEmpty {
                    inventorySection(category: category, items: items)
                }
            }

            if visibleItemCount == 0 {
                emptyState
            }
        }
    }

    private func inventorySection(category: InventoryCategory, items: [InventoryItem]) -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            HStack(alignment: .firstTextBaseline) {
                Text(sectionTitle(for: category))
                    .font(Theme.Typography.subhead.weight(.semibold))
                    .foregroundStyle(Theme.Colors.textPrimary)

                Spacer()

                Text("\(items.count) item\(items.count == 1 ? "" : "s")")
                    .font(Theme.Typography.micro.weight(.semibold))
                    .foregroundStyle(Theme.Colors.textSecondary)
            }

            VStack(spacing: Theme.Spacing.sm) {
                ForEach(items) { item in
                    inventoryRow(item)
                }
            }
        }
    }

    private func inventoryRow(_ item: InventoryItem) -> some View {
        HStack(alignment: .center, spacing: Theme.Spacing.md) {
            categoryIcon(item.category, size: 48)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(Theme.Typography.body.weight(.semibold))
                    .foregroundStyle(Theme.Colors.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                Text(item.category.rawValue)
                    .font(Theme.Typography.micro)
                    .foregroundStyle(Theme.Colors.textSecondary)
                    .lineLimit(1)
            }

            Spacer(minLength: Theme.Spacing.sm)

            quantityControl(for: item)
        }
        .padding(Theme.Spacing.md)
        .background(Theme.Colors.background)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.md)
                .stroke(Theme.Colors.divider)
        )
    }

    private func quantityControl(for item: InventoryItem) -> some View {
        VStack(spacing: Theme.Spacing.xs) {
            Text(quantityText(for: item))
                .font(Theme.Typography.caption.weight(.semibold))
                .foregroundStyle(Theme.Colors.textPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
                .frame(width: 58)

            HStack(spacing: Theme.Spacing.xs) {
                quantityButton(systemName: "minus", item: item, delta: -stepSize(for: item))
                quantityButton(systemName: "plus", item: item, delta: stepSize(for: item))
            }
        }
    }

    private func categoryIcon(_ category: InventoryCategory, size: CGFloat) -> some View {
        Image(systemName: iconName(for: category))
            .font(.system(size: size * 0.42, weight: .semibold))
            .foregroundStyle(Theme.Colors.primary)
            .frame(width: size, height: size)
            .background(Theme.Colors.primaryLight)
            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm))
    }

    private func quantityButton(systemName: String, item: InventoryItem, delta: Double) -> some View {
        Button {
            updateQuantity(for: item, delta: delta)
        } label: {
            Image(systemName: systemName)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Theme.Colors.textPrimary)
                .frame(width: 28, height: 28)
                .background(Theme.Colors.surface)
                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm))
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Radius.sm)
                        .stroke(Theme.Colors.divider)
                )
        }
        .buttonStyle(.plain)
    }

    private var emptyState: some View {
        VStack(spacing: Theme.Spacing.sm) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: Theme.IconSize.lg, weight: .semibold))
                .foregroundStyle(Theme.Colors.textTertiary)

            Text("No ingredients found")
                .font(Theme.Typography.subhead)
                .foregroundStyle(Theme.Colors.textPrimary)

            Text("Try a different search or add it as a custom item.")
                .font(Theme.Typography.caption)
                .foregroundStyle(Theme.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Theme.Spacing.xl)
    }

    private var shouldShowSuggestions: Bool {
        !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var visibleItemCount: Int {
        sectionOrder.reduce(0) { count, category in
            count + filteredItems(for: category).count
        }
    }

    private var matchingSuggestions: [InventoryItem] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !query.isEmpty else { return [] }

        return DefaultInventoryItems.all.filter { item in
            item.name.lowercased().contains(query)
                && !inventory.contains(where: { $0.name.caseInsensitiveCompare(item.name) == .orderedSame })
        }
    }

    private func filteredItems(for category: InventoryCategory) -> [InventoryItem] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        return inventory.filter { item in
            item.category == category
                && selectedFilter.includes(item.category)
                && (query.isEmpty || item.name.lowercased().contains(query))
        }
    }

    private func loadInventoryForCurrentUser() {
        guard let userId = authViewModel.currentUser?.id else {
            inventory = []
            return
        }

        inventory = loadInventory(userId: userId)
    }

    private func persistInventory() {
        guard let userId = authViewModel.currentUser?.id else { return }
        saveInventory(userId: userId, inventory: inventory)
    }

    private func addItem(_ item: InventoryItem) {
        if let index = inventory.firstIndex(where: { $0.name.caseInsensitiveCompare(item.name) == .orderedSame }) {
            inventory[index].quantity += stepSize(for: inventory[index])
        } else {
            inventory.insert(item, at: 0)
        }

        searchText = ""
        persistInventory()
    }

    private func addCustomItem() {
        let name = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return }

        let item = InventoryItem(name: name, quantity: 1, unit: "pcs", category: categoryForCustomItem())
        addItem(item)
    }

    private func updateQuantity(for item: InventoryItem, delta: Double) {
        guard let index = inventory.firstIndex(where: { $0.id == item.id }) else { return }

        let updatedQuantity = inventory[index].quantity + delta
        if updatedQuantity <= 0 {
            inventory.remove(at: index)
        } else {
            inventory[index].quantity = updatedQuantity
        }

        persistInventory()
    }

    private func categoryForCustomItem() -> InventoryCategory {
        switch selectedFilter {
        case .pantry:
            return .pantry
        case .freezer:
            return .frozen
        case .fridge:
            return .dairy
        case .all:
            return .produce
        }
    }

    private func sectionTitle(for category: InventoryCategory) -> String {
        switch category {
        case .meat:
            return "Protein"
        default:
            return category.rawValue
        }
    }

    private func iconName(for category: InventoryCategory) -> String {
        switch category {
        case .produce:
            return "leaf"
        case .dairy:
            return "takeoutbag.and.cup.and.straw"
        case .pantry:
            return "cabinet"
        case .meat:
            return "fork.knife"
        case .frozen:
            return "snowflake"
        }
    }

    private func quantityText(for item: InventoryItem) -> String {
        let value = item.quantity.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(item.quantity)) : String(format: "%.1f", item.quantity)
        return "\(value) \(item.unit)"
    }

    private func stepSize(for item: InventoryItem) -> Double {
        switch item.unit.lowercased() {
        case "g", "ml":
            return 50
        default:
            return 1
        }
    }

}

private enum InventoryFilter: CaseIterable, Identifiable {
    case all
    case fridge
    case pantry
    case freezer

    var id: Self { self }

    var title: String {
        switch self {
        case .all:
            return "All"
        case .fridge:
            return "Fridge"
        case .pantry:
            return "Pantry"
        case .freezer:
            return "Freezer"
        }
    }

    func includes(_ category: InventoryCategory) -> Bool {
        switch self {
        case .all:
            return true
        case .fridge:
            return category == .produce || category == .dairy || category == .meat
        case .pantry:
            return category == .pantry
        case .freezer:
            return category == .frozen
        }
    }
}
