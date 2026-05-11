//
//  PotluckDetailsView.swift
//  MealPrep
//
//  Created by Enerel Tsolmonbayar on 11/5/2026.
//

import SwiftUI

struct PotluckDetailsView: View {
    let potluck: PotluckEvent

    @Environment(\.dismiss) private var dismiss
    @State private var contributedRecipes: [Recipe] = []
    @State private var showRecipePicker = false
    @State private var showPeopleList = false

    private var dateText: String {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMM d, h:mm a")
        return formatter.string(from: potluck.date)
    }

    private var recipes: [Recipe] {
        contributedRecipes
    }

    private var peopleComing: [String] {
        var names = [potluck.hostName, "Alex Rivera", "Jordan M.", "Sarah K."]
        names.append(contentsOf: contributedRecipes.map { recipe in
            recipe.authorUsername.isEmpty ? "Guest Contributor" : recipe.authorUsername
        })
        return Array(NSOrderedSet(array: names).compactMap { $0 as? String })
    }

    private var peopleComingCount: Int {
        peopleComing.count
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                topBar
                heroCard
                eventSummaryCard
                peopleComingSection
                aboutSection
                recipesSection
                addRecipeButton
            }
            .padding(Theme.Spacing.md)
            .padding(.bottom, Theme.Spacing.xl)
        }
        .background(Theme.Colors.surface)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear(perform: loadContributedRecipes)
        .sheet(isPresented: $showRecipePicker) {
            PotluckRecipePickerSheet(selectedRecipes: recipes) { recipe in
                addRecipe(recipe)
            }
        }
        .sheet(isPresented: $showPeopleList) {
            PeopleComingSheet(names: peopleComing)
        }
    }

    private var topBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: Theme.IconSize.sm, weight: .semibold))
                    .foregroundStyle(Theme.Colors.textPrimary)
                    .frame(width: 38, height: 38)
            }
            .accessibilityLabel("Back")

            Spacer()

            Text("Potluck")
                .font(Theme.Typography.heading)
                .foregroundStyle(Theme.Colors.primary)

            Spacer()

            Button {
            } label: {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: Theme.IconSize.sm, weight: .semibold))
                    .foregroundStyle(Theme.Colors.textPrimary)
                    .frame(width: 38, height: 38)
            }
            .accessibilityLabel("Share")
        }
    }

    private var heroCard: some View {
        ZStack(alignment: .bottomLeading) {
            Image("mealprep")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 180)
                .clipped()
                .overlay(Color.black.opacity(0.24))

            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                Text(potluck.category.uppercased())
                    .font(Theme.Typography.micro)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.horizontal, Theme.Spacing.sm)
                    .padding(.vertical, Theme.Spacing.xs)
                    .background(Theme.Colors.primary)
                    .clipShape(Capsule())

                Text(potluck.title)
                    .font(Theme.Typography.heading)
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
            }
            .padding(Theme.Spacing.md)
        }
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
    }

    private var eventSummaryCard: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                Label(dateText, systemImage: "calendar")
                if !potluck.location.isEmpty {
                    Label(potluck.location, systemImage: "mappin.and.ellipse")
                }
            }
            .font(Theme.Typography.body)
            .foregroundStyle(Theme.Colors.textSecondary)

            Divider()

            HStack(spacing: Theme.Spacing.md) {
                Circle()
                    .fill(Theme.Colors.primaryLight)
                    .frame(width: 42, height: 42)
                    .overlay {
                        Image(systemName: "person.fill")
                            .font(.system(size: Theme.IconSize.sm, weight: .semibold))
                            .foregroundStyle(Theme.Colors.primary)
                    }

                VStack(alignment: .leading, spacing: 2) {
                    Text("Hosted by")
                        .font(Theme.Typography.caption)
                        .foregroundStyle(Theme.Colors.textSecondary)
                    Text(potluck.hostName)
                        .font(Theme.Typography.subhead)
                        .foregroundStyle(Theme.Colors.textPrimary)
                }
            }
        }
        .padding(Theme.Spacing.md)
        .background(Theme.Colors.background)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.md)
                .stroke(Theme.Colors.divider)
        )
    }

    private var peopleComingSection: some View {
        sectionCard(title: "People Coming (\(peopleComingCount))") {
            HStack(spacing: -Theme.Spacing.sm) {
                ForEach(0..<min(3, peopleComingCount), id: \.self) { index in
                    Circle()
                        .fill(Theme.Colors.primaryLight)
                        .frame(width: 42, height: 42)
                        .overlay {
                            Image(systemName: "person.fill")
                                .font(.system(size: Theme.IconSize.sm, weight: .semibold))
                                .foregroundStyle(index == 0 ? Theme.Colors.primary : Theme.Colors.tertiary)
                        }
                        .overlay(Circle().stroke(Theme.Colors.background, lineWidth: 2))
                }

                if peopleComingCount > 3 {
                    Text("+\(peopleComingCount - 3)")
                        .font(Theme.Typography.subhead)
                        .foregroundStyle(Theme.Colors.textPrimary)
                        .frame(width: 42, height: 42)
                        .background(Theme.Colors.primaryLight)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Theme.Colors.background, lineWidth: 2))
                }

                Spacer()

                Button("View All") {
                    showPeopleList = true
                }
                .font(Theme.Typography.caption.weight(.semibold))
                .foregroundStyle(Theme.Colors.primary)
            }
        }
    }

    private var aboutSection: some View {
        sectionCard(title: "About the Event") {
            Text("Bring your favorite dish, prep-friendly sides, or a recipe you want to share. This potluck is a simple way to meet local cooks and swap ideas for easier weekly meals.")
                .font(Theme.Typography.body)
                .foregroundStyle(Theme.Colors.textSecondary)
                .lineSpacing(3)
        }
    }

    private var recipesSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text("Recipes (\(recipes.count))")
                .font(Theme.Typography.heading)
                .foregroundStyle(Theme.Colors.textPrimary)

            if recipes.isEmpty {
                emptyRecipesState
            } else {
                VStack(spacing: Theme.Spacing.sm) {
                    ForEach(Array(recipes.enumerated()), id: \.element.id) { index, recipe in
                        recipeRow(recipe: recipe, isContribution: index == 0)
                    }
                }
            }
        }
    }

    private var emptyRecipesState: some View {
        VStack(spacing: Theme.Spacing.sm) {
            Image(systemName: "fork.knife.circle")
                .font(.system(size: Theme.IconSize.lg, weight: .semibold))
                .foregroundStyle(Theme.Colors.primary)

            Text("No recipes yet")
                .font(Theme.Typography.subhead)
                .foregroundStyle(Theme.Colors.textPrimary)

            Text("Add your first recipe contribution for this potluck.")
                .font(Theme.Typography.body)
                .foregroundStyle(Theme.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(Theme.Spacing.lg)
        .background(Theme.Colors.background)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.md)
                .stroke(Theme.Colors.divider)
        )
    }

    private func recipeRow(recipe: Recipe, isContribution: Bool) -> some View {
        HStack(spacing: Theme.Spacing.md) {
            AsyncImage(url: URL(string: recipe.imageURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Rectangle()
                    .fill(Theme.Colors.surface)
                    .overlay {
                        Image(systemName: "fork.knife")
                            .foregroundStyle(Theme.Colors.textTertiary)
                    }
            }
            .frame(width: 64, height: 64)
            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm))

            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                Text(recipe.name)
                    .font(Theme.Typography.subhead)
                    .foregroundStyle(Theme.Colors.textPrimary)
                    .lineLimit(2)

                Text(isContribution ? "Your Contribution" : recipe.authorUsername.isEmpty ? potluck.hostName : recipe.authorUsername)
                    .font(Theme.Typography.caption)
                    .foregroundStyle(isContribution ? Theme.Colors.primary : Theme.Colors.textSecondary)
            }

            Spacer(minLength: Theme.Spacing.sm)

            if isContribution {
                Button {
                    removeRecipe(recipe)
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: Theme.IconSize.sm, weight: .semibold))
                        .foregroundStyle(.red)
                        .frame(width: 34, height: 34)
                }
                .accessibilityLabel("Remove recipe")
            }
        }
        .padding(Theme.Spacing.sm)
        .background(Theme.Colors.background)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.md)
                .stroke(Theme.Colors.divider)
        )
    }

    private var addRecipeButton: some View {
        Button {
            showRecipePicker = true
        } label: {
            Label("Add Your Recipe", systemImage: "plus")
                .font(Theme.Typography.subhead)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Theme.Spacing.md)
                .background(Theme.Colors.primary)
                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
        }
    }

    private func sectionCard<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            Text(title)
                .font(Theme.Typography.heading)
                .foregroundStyle(Theme.Colors.textPrimary)
            content()
        }
        .padding(Theme.Spacing.md)
        .background(Theme.Colors.background)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.md)
                .stroke(Theme.Colors.divider)
        )
    }

    private func addRecipe(_ recipe: Recipe) {
        guard !contributedRecipes.contains(where: { $0.id == recipe.id || $0.name == recipe.name }) else { return }
        contributedRecipes.insert(recipe, at: 0)
        saveContributedRecipes()
        showRecipePicker = false
    }

    private func removeRecipe(_ recipe: Recipe) {
        contributedRecipes.removeAll { $0.id == recipe.id }
        saveContributedRecipes()
    }

    private func loadContributedRecipes() {
        guard let data = UserDefaults.standard.data(forKey: recipeStorageKey),
              let decoded = try? JSONDecoder().decode([Recipe].self, from: data)
        else {
            contributedRecipes = []
            return
        }

        contributedRecipes = decoded
    }

    private func saveContributedRecipes() {
        guard let encoded = try? JSONEncoder().encode(contributedRecipes) else { return }
        UserDefaults.standard.set(encoded, forKey: recipeStorageKey)
    }

    private var recipeStorageKey: String {
        "potluck_recipes_\(potluck.id.uuidString)"
    }
}

private struct PeopleComingSheet: View {
    let names: [String]

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(Array(names.enumerated()), id: \.offset) { index, name in
                    HStack(spacing: Theme.Spacing.md) {
                        Circle()
                            .fill(Theme.Colors.primaryLight)
                            .frame(width: 42, height: 42)
                            .overlay {
                                Image(systemName: "person.fill")
                                    .font(.system(size: Theme.IconSize.sm, weight: .semibold))
                                    .foregroundStyle(index == 0 ? Theme.Colors.primary : Theme.Colors.tertiary)
                            }

                        VStack(alignment: .leading, spacing: 2) {
                            Text(name)
                                .font(Theme.Typography.subhead)
                                .foregroundStyle(Theme.Colors.textPrimary)

                            Text(index == 0 ? "Host" : "Guest")
                                .font(Theme.Typography.caption)
                                .foregroundStyle(Theme.Colors.textSecondary)
                        }
                    }
                    .padding(.vertical, Theme.Spacing.xs)
                }
            }
            .navigationTitle("People Coming")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundStyle(Theme.Colors.primary)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}

private struct PotluckRecipePickerSheet: View {
    let selectedRecipes: [Recipe]
    let onSelect: (Recipe) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var selectedFilter: RecipeFilter = .all
    @State private var localSelectedRecipes: [Recipe]

    init(selectedRecipes: [Recipe], onSelect: @escaping (Recipe) -> Void) {
        self.selectedRecipes = selectedRecipes
        self.onSelect = onSelect
        _localSelectedRecipes = State(initialValue: selectedRecipes)
    }

    private var filteredRecipes: [Recipe] {
        MockRecipes.all.filter { recipe in
            selectedFilter.includes(recipe)
                && (searchText.isEmpty
                    || recipe.name.localizedCaseInsensitiveContains(searchText)
                    || recipe.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
                    || recipe.cuisine.localizedCaseInsensitiveContains(searchText))
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: Theme.Spacing.md) {
                    searchField
                    filterChips

                    if filteredRecipes.isEmpty {
                        emptyFilterState
                    } else {
                        ForEach(filteredRecipes.prefix(20)) { recipe in
                            pickerRecipeCard(recipe)
                        }
                    }
                }
                .padding(Theme.Spacing.md)
                .padding(.bottom, Theme.Spacing.xl)
            }
            .background(Theme.Colors.surface)
            .navigationTitle("Add Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundStyle(Theme.Colors.primary)
                }
            }
        }
    }

    private var searchField: some View {
        HStack(spacing: Theme.Spacing.sm) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: Theme.IconSize.sm, weight: .semibold))
                .foregroundStyle(Theme.Colors.textSecondary)

            TextField("Search my recipes...", text: $searchText)
                .font(Theme.Typography.caption)
                .textInputAutocapitalization(.words)

            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Theme.Colors.textTertiary)
                }
            }
        }
        .padding(.horizontal, Theme.Spacing.md)
        .frame(height: 48)
        .background(Theme.Colors.background)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.sm)
                .stroke(Theme.Colors.divider)
        )
    }

    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Theme.Spacing.sm) {
                ForEach(RecipeFilter.allCases) { filter in
                    Button {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            selectedFilter = filter
                        }
                    } label: {
                        Text(filter.title)
                            .font(Theme.Typography.micro.weight(.semibold))
                            .foregroundStyle(selectedFilter == filter ? Theme.Colors.primary : Theme.Colors.textPrimary)
                            .padding(.horizontal, Theme.Spacing.sm)
                            .padding(.vertical, Theme.Spacing.xs)
                            .background(selectedFilter == filter ? Theme.Colors.primaryLight : Theme.Colors.background)
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

    private var emptyFilterState: some View {
        VStack(spacing: Theme.Spacing.sm) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: Theme.IconSize.lg, weight: .semibold))
                .foregroundStyle(Theme.Colors.textTertiary)

            Text("No recipes found")
                .font(Theme.Typography.subhead)
                .foregroundStyle(Theme.Colors.textPrimary)

            Text("Try another filter or search term.")
                .font(Theme.Typography.caption)
                .foregroundStyle(Theme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Theme.Spacing.xl)
        .background(Theme.Colors.background)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.md)
                .stroke(Theme.Colors.divider)
        )
    }

    private func pickerRecipeCard(_ recipe: Recipe) -> some View {
        let alreadySelected = localSelectedRecipes.contains { $0.id == recipe.id || $0.name == recipe.name }

        return VStack(alignment: .leading, spacing: 0) {
            AsyncImage(url: URL(string: recipe.imageURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Rectangle()
                    .fill(Theme.Colors.surface)
                    .overlay {
                        Image(systemName: "fork.knife")
                            .foregroundStyle(Theme.Colors.textTertiary)
                    }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 150)
            .clipped()

            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                HStack(alignment: .bottom, spacing: Theme.Spacing.md) {
                    VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                        Text(recipe.name)
                            .font(Theme.Typography.subhead)
                            .foregroundStyle(Theme.Colors.textPrimary)
                            .lineLimit(2)

                        Text("\(recipe.cookTimeMinutes) min • Serves \(recipe.servings)")
                            .font(Theme.Typography.micro)
                            .foregroundStyle(Theme.Colors.textSecondary)
                    }

                    Spacer()

                    Button {
                        guard !alreadySelected else { return }
                        localSelectedRecipes.append(recipe)
                        onSelect(recipe)
                        dismiss()
                    } label: {
                        HStack(spacing: Theme.Spacing.xs) {
                            Image(systemName: alreadySelected ? "checkmark" : "plus.circle")
                            Text(alreadySelected ? "Added" : "Select")
                        }
                        .font(Theme.Typography.caption.weight(.semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, Theme.Spacing.md)
                        .padding(.vertical, Theme.Spacing.sm)
                        .background(alreadySelected ? Theme.Colors.success : Theme.Colors.primary)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm))
                    }
                    .disabled(alreadySelected)
                }

                if !recipe.tags.isEmpty {
                    HStack(spacing: Theme.Spacing.xs) {
                        ForEach(recipe.tags.prefix(2), id: \.self) { tag in
                            Text(tag.uppercased())
                                .font(Theme.Typography.micro.weight(.semibold))
                                .foregroundStyle(Theme.Colors.textSecondary)
                                .padding(.horizontal, Theme.Spacing.xs)
                                .padding(.vertical, 3)
                                .background(Theme.Colors.surface)
                                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm))
                        }
                    }
                }
            }
            .padding(Theme.Spacing.md)
            .background(Theme.Colors.background)
        }
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.md)
                .stroke(Theme.Colors.divider)
        )
    }
}

private enum RecipeFilter: CaseIterable, Identifiable {
    case all
    case mains
    case sides
    case desserts

    var id: Self { self }

    var title: String {
        switch self {
        case .all:
            return "All Recipes"
        case .mains:
            return "Mains"
        case .sides:
            return "Sides"
        case .desserts:
            return "Desserts"
        }
    }

    func includes(_ recipe: Recipe) -> Bool {
        switch self {
        case .all:
            return true
        case .mains:
            return recipeCategory(for: recipe) == .mains
        case .sides:
            return recipeCategory(for: recipe) == .sides
        case .desserts:
            return recipeCategory(for: recipe) == .desserts
        }
    }

    private func recipeCategory(for recipe: Recipe) -> RecipeFilter {
        if matches(recipe, keywords: ["dessert", "sweet", "cake", "chocolate", "pancake", "honey", "berry", "fruit"]) {
            return .desserts
        }

        if matches(recipe, keywords: ["side", "snack", "salad", "toast", "salsa", "slaw", "bread", "quick", "vegetarian"]) {
            return .sides
        }

        return .mains
    }

    private func matches(_ recipe: Recipe, keywords: [String]) -> Bool {
        let searchableText = ([recipe.name, recipe.cuisine, recipe.mealType] + recipe.tags)
            .joined(separator: " ")
            .lowercased()

        return keywords.contains { searchableText.contains($0) }
    }
}

