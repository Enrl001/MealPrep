//
//  AddMealSheet.swift
//  
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//
import SwiftUI

struct AddMealSheet: View {
    @ObservedObject var viewModel: ScheduleViewModel
    let recipe: Recipe?
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var authViewModel: AuthViewModel

    @State private var recipeName = ""
    @State private var selectedMealType: MealType = .breakfast
    @State private var selectedDay = "Mon"
    @State private var selectedTime = "08:30 AM"
    @State private var repeatWeekly = true
    @State private var selectedRepeatDays: Set<String> = ["M0", "W2", "F4"]

    private let guestMealLimit = 5

    private var isGuestLimitReached: Bool {
        authViewModel.currentUser == nil && viewModel.mealEvents.count >= guestMealLimit
    }

    init(viewModel: ScheduleViewModel, recipe: Recipe? = nil) {
        self.viewModel = viewModel
        self.recipe = recipe
        _recipeName = State(initialValue: recipe?.name ?? "")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
            sheetHeader
            if let recipe {
                recipeSummary(recipe)
            }
            recipeNameField
            mealTypePicker
            dateAndTimeFields
            repeatSection

            Spacer()

            addMealButton
        }
        .padding(Theme.Spacing.md)
        .background(Theme.Colors.background)
    }

    private var sheetHeader: some View {
        HStack {
            Text("Add to Schedule")
                .font(Theme.Typography.subhead)
                .foregroundColor(Theme.Colors.textPrimary)

            Spacer()

            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(Theme.Colors.textSecondary)
            }
        }
    }

    private var recipeNameField: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Text("Recipe Name")
                .font(Theme.Typography.caption.bold())
                .foregroundColor(Theme.Colors.textSecondary)

            TextField("Enter meal name", text: $recipeName)
                .padding()
                .background(Theme.Colors.surface)
                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
                .disabled(recipe != nil)
        }
    }

    private func recipeSummary(_ recipe: Recipe) -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Text("Selected Recipe")
                .font(Theme.Typography.caption.bold())
                .foregroundColor(Theme.Colors.textSecondary)

            HStack(spacing: Theme.Spacing.sm) {
                Image(systemName: "fork.knife")
                    .font(.system(size: Theme.IconSize.md, weight: .semibold))
                    .foregroundColor(Theme.Colors.primary)
                    .frame(width: 40, height: 40)
                    .background(Theme.Colors.primaryLight)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm))

                VStack(alignment: .leading, spacing: 2) {
                    Text(recipe.name)
                        .font(Theme.Typography.subhead)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .lineLimit(1)

                    Text("\(recipe.ingredients.count) ingredients")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                }

                Spacer()
            }
            .padding()
            .background(Theme.Colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
        }
    }

    private var mealTypePicker: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Text("Meal Type")
                .font(Theme.Typography.caption.bold())
                .foregroundColor(Theme.Colors.textSecondary)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 105))], spacing: Theme.Spacing.sm) {
                ForEach(MealType.allCases) { type in
                    Button {
                        selectedMealType = type
                    } label: {
                        Text(type.rawValue)
                            .font(Theme.Typography.caption.bold())
                            .foregroundColor(type.color)
                            .padding(.horizontal, Theme.Spacing.md)
                            .padding(.vertical, Theme.Spacing.sm)
                            .background(selectedMealType == type ? type.lightColor : Theme.Colors.background)
                            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
                            .overlay(
                                RoundedRectangle(cornerRadius: Theme.Radius.md)
                                    .stroke(selectedMealType == type ? type.color : Theme.Colors.divider)
                            )
                    }
                }
            }
        }
    }

    private var dateAndTimeFields: some View {
        HStack(spacing: Theme.Spacing.md) {
            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                Text("Date")
                    .font(Theme.Typography.caption.bold())
                    .foregroundColor(Theme.Colors.textSecondary)

                Picker("Day", selection: $selectedDay) {
                    ForEach(viewModel.fullDays, id: \.self) { day in
                        Text(day)
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Theme.Colors.surface)
                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
            }

            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                Text("Time")
                    .font(Theme.Typography.caption.bold())
                    .foregroundColor(Theme.Colors.textSecondary)

                TextField("08:30 AM", text: $selectedTime)
                    .padding()
                    .background(Theme.Colors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
            }
        }
    }

    private var repeatSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    Text("Repeat Weekly")
                        .font(Theme.Typography.subhead)
                        .foregroundColor(Theme.Colors.textPrimary)

                    Text("Select days for repeating this meal")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                }

                Spacer()

                Toggle("", isOn: $repeatWeekly)
                    .labelsHidden()
                    .tint(Theme.Colors.primary)
            }

            if repeatWeekly {
                MealRepeatPickerView(selectedDays: $selectedRepeatDays)
            }
        }
        .padding()
        .background(Theme.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.lg))
    }

    private var addMealButton: some View {
        VStack(spacing: Theme.Spacing.sm) {
            if isGuestLimitReached {
                Text("Guests can schedule up to \(guestMealLimit) meals. Log in to add more.")
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }

            Button {
                guard !isGuestLimitReached else { return }

                let finalName = recipeName.isEmpty ? "New Meal" : recipeName
                let missingIngredients = missingIngredientsForRecipe()

                viewModel.addMeal(
                    recipeName: finalName,
                    mealType: selectedMealType,
                    day: selectedDay,
                    time: selectedTime,
                    recipe: recipe,
                    ingredients: recipe?.ingredients ?? [],
                    missingIngredients: missingIngredients
                )

                notifyForMissingIngredientsIfNeeded(missingIngredients)
                syncRecipeIngredientsToGroceryList()

                dismiss()
            } label: {
                Text("Add to Schedule")
                    .font(Theme.Typography.subhead)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isGuestLimitReached ? Theme.Colors.textTertiary : Theme.Colors.primary)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
            }
            .disabled(isGuestLimitReached)
        }
    }

    private func missingIngredientsForRecipe() -> [Ingredient] {
        guard let recipe,
              let userId = authViewModel.currentUser?.id else {
            return []
        }

        let inventory = loadInventory(userId: userId)
        return recipe.ingredients.filter { ingredient in
            !inventory.contains { inventoryItem in
                ingredientMatchesInventory(ingredient.name, inventoryItem.name)
            }
        }
    }

    private func notifyForMissingIngredientsIfNeeded(_ missingIngredients: [Ingredient]) {
        guard let recipe else {
            return
        }

        NotificationStore.shared.addMissingIngredientsNotification(
            recipeName: recipe.name,
            missingIngredients: missingIngredients
        )
    }

    private func syncRecipeIngredientsToGroceryList() {
        guard let recipe,
              let userId = authViewModel.currentUser?.id else {
            return
        }

        let inventory = loadInventory(userId: userId)
        UserDefaultManager.shared.addRecipeIngredientsToCurrentGroceryList(
            recipeName: recipe.name,
            ingredients: recipe.ingredients,
            inventory: inventory
        )
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
}
