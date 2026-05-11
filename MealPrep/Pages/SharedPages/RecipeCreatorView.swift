//
//  RecipeCreatorView.swift
//  
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//

import SwiftUI

struct RecipeCreatorView: View {
    @Environment(\.dismiss) private var dismiss

    let authorUsername: String
    let onSave: (Recipe) -> Void

    @State private var title = ""
    @State private var description = ""
    @State private var prepTime = 15
    @State private var cookTime = 45
    @State private var servings = 4
    @State private var selectedCourse = "Main"
    @State private var selectedMealTime = "Dinner"
    @State private var isPublic = true
    @State private var ingredients: [DraftIngredient] = [DraftIngredient()]
    @State private var steps: [DraftStep] = [DraftStep()]

    private let courseOptions = ["Entree", "Main", "Dessert", "Drinks"]
    private let mealTimeOptions = ["Breakkie", "Brunch", "Lunch", "Supper", "Dinner"]

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                    coverPhotoSection
                    textFieldsSection
                    quickStatsSection
                    optionSection(title: "Course", options: courseOptions, selection: $selectedCourse)
                    optionSection(title: "Meal Time", options: mealTimeOptions, selection: $selectedMealTime)
                    visibilitySection
                    ingredientsSection
                    stepsSection
                }
                .padding(Theme.Spacing.md)
            }
            .background(Theme.Colors.surface)
            .navigationTitle("Create Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveRecipe()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }

    private var coverPhotoSection: some View {
        VStack(spacing: Theme.Spacing.sm) {
            Image(systemName: "camera.badge.plus")
                .font(.system(size: Theme.IconSize.lg, weight: .semibold))
                .foregroundStyle(Theme.Colors.primary)
                .frame(width: 64, height: 64)
                .background(Theme.Colors.background)
                .clipShape(Circle())

            Text("Upload Cover Photo")
                .font(Theme.Typography.subhead)
                .foregroundStyle(Theme.Colors.textPrimary)

            Text("PNG or JPG, up to 10MB")
                .font(Theme.Typography.caption)
                .foregroundStyle(Theme.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(Theme.Spacing.lg)
        .background(Theme.Colors.background)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.md)
                .stroke(Theme.Colors.divider, style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
        )
    }

    private var textFieldsSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            labeledField(title: "Recipe Title", placeholder: "e.g. Lemon Herb Roasted Chicken", text: $title)

            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                Text("Description")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(Theme.Colors.textPrimary)
                    .textCase(.uppercase)

                TextEditor(text: $description)
                    .font(Theme.Typography.body)
                    .frame(minHeight: 88)
                    .padding(Theme.Spacing.sm)
                    .background(Theme.Colors.background)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm))
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.Radius.sm)
                            .stroke(Theme.Colors.divider)
                    )
            }
        }
    }

    private var quickStatsSection: some View {
        VStack(spacing: Theme.Spacing.sm) {
            stepperRow(icon: "clock", title: "Prep Time", value: "\(prepTime) min") {
                Stepper("", value: $prepTime, in: 5...240, step: 5)
                    .labelsHidden()
            }
            stepperRow(icon: "frying.pan", title: "Cook Time", value: "\(cookTime) min") {
                Stepper("", value: $cookTime, in: 0...240, step: 5)
                    .labelsHidden()
            }
            stepperRow(icon: "fork.knife", title: "Servings", value: "\(servings) people") {
                Stepper("", value: $servings, in: 1...20)
                    .labelsHidden()
            }
        }
    }

    private var visibilitySection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Text("Visibility")
                .font(Theme.Typography.caption)
                .foregroundStyle(Theme.Colors.textPrimary)
                .textCase(.uppercase)

            Toggle(isOn: $isPublic) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(isPublic ? "Public Recipe" : "Private Recipe")
                        .font(Theme.Typography.subhead)
                        .foregroundStyle(Theme.Colors.textPrimary)
                    Text(isPublic ? "Visible to other cooks" : "Only visible in My Recipes")
                        .font(Theme.Typography.caption)
                        .foregroundStyle(Theme.Colors.textSecondary)
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
    }

    private var ingredientsSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            HStack {
                Text("Ingredients")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(Theme.Colors.textPrimary)
                    .textCase(.uppercase)
                Spacer()
                Button {
                    ingredients.append(DraftIngredient())
                } label: {
                    Label("Add Ingredient", systemImage: "plus.circle")
                        .font(Theme.Typography.caption)
                }
                .foregroundStyle(Theme.Colors.primary)
            }

            ForEach($ingredients) { $ingredient in
                HStack(spacing: Theme.Spacing.sm) {
                    TextField("Qty", text: $ingredient.quantity)
                        .frame(width: 48)
                    TextField("Unit", text: $ingredient.unit)
                        .frame(width: 58)
                    TextField("Ingredient name", text: $ingredient.name)
                    Button {
                        ingredients.removeAll { $0.id == ingredient.id }
                    } label: {
                        Image(systemName: "trash")
                            .foregroundStyle(Theme.Colors.textTertiary)
                    }
                    .disabled(ingredients.count == 1)
                }
                .font(Theme.Typography.body)
                .padding(Theme.Spacing.sm)
                .background(Theme.Colors.background)
                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm))
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Radius.sm)
                        .stroke(Theme.Colors.divider)
                )
            }
        }
    }

    private var stepsSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            HStack {
                Text("Preparation Steps")
                    .font(Theme.Typography.caption)
                    .foregroundStyle(Theme.Colors.textPrimary)
                    .textCase(.uppercase)
                Spacer()
                Button {
                    steps.append(DraftStep())
                } label: {
                    Label("Add Step", systemImage: "text.badge.plus")
                        .font(Theme.Typography.caption)
                }
                .foregroundStyle(Theme.Colors.primary)
            }

            ForEach(Array($steps.enumerated()), id: \.element.id) { index, $step in
                HStack(alignment: .top, spacing: Theme.Spacing.sm) {
                    Text("\(index + 1)")
                        .font(Theme.Typography.micro)
                        .foregroundStyle(.white)
                        .frame(width: 28, height: 28)
                        .background(Theme.Colors.primary)
                        .clipShape(Circle())

                    VStack(spacing: Theme.Spacing.sm) {
                        TextField("Step title", text: $step.title)
                            .font(Theme.Typography.body)
                        TextEditor(text: $step.description)
                            .font(Theme.Typography.body)
                            .frame(minHeight: 72)
                    }
                    .padding(Theme.Spacing.sm)
                    .background(Theme.Colors.background)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm))
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.Radius.sm)
                            .stroke(Theme.Colors.divider)
                    )
                }
            }
        }
    }

    private func optionSection(title: String, options: [String], selection: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Text(title)
                .font(Theme.Typography.caption)
                .foregroundStyle(Theme.Colors.textPrimary)
                .textCase(.uppercase)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 96), spacing: Theme.Spacing.sm)], alignment: .leading, spacing: Theme.Spacing.sm) {
                ForEach(options, id: \.self) { option in
                    Button {
                        selection.wrappedValue = option
                    } label: {
                        HStack(spacing: Theme.Spacing.xs) {
                            if selection.wrappedValue == option {
                                Image(systemName: "checkmark")
                                    .font(.system(size: Theme.IconSize.sm, weight: .semibold))
                            }
                            Text(option)
                                .lineLimit(1)
                                .minimumScaleFactor(0.85)
                        }
                        .font(Theme.Typography.body)
                        .foregroundStyle(selection.wrappedValue == option ? Theme.Colors.primary : Theme.Colors.textPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, Theme.Spacing.sm)
                        .padding(.vertical, Theme.Spacing.sm)
                        .background(Theme.Colors.background)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm))
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.Radius.sm)
                                .stroke(selection.wrappedValue == option ? Theme.Colors.primary : Theme.Colors.divider)
                        )
                    }
                }
            }
        }
    }

    private func labeledField(title: String, placeholder: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Text(title)
                .font(Theme.Typography.caption)
                .foregroundStyle(Theme.Colors.textPrimary)
                .textCase(.uppercase)
            TextField(placeholder, text: text)
                .font(Theme.Typography.body)
                .padding(Theme.Spacing.md)
                .background(Theme.Colors.background)
                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm))
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Radius.sm)
                        .stroke(Theme.Colors.divider)
                )
        }
    }

    private func stepperRow<Control: View>(icon: String, title: String, value: String, control: () -> Control) -> some View {
        HStack(spacing: Theme.Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: Theme.IconSize.sm, weight: .semibold))
                .foregroundStyle(Theme.Colors.primary)
                .frame(width: 40, height: 40)
                .background(Theme.Colors.primaryLight)
                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(Theme.Typography.subhead)
                    .foregroundStyle(Theme.Colors.textPrimary)
                Text(value)
                    .font(Theme.Typography.caption)
                    .foregroundStyle(Theme.Colors.textSecondary)
            }

            Spacer()
            control()
        }
        .padding(Theme.Spacing.md)
        .background(Theme.Colors.background)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.md)
                .stroke(Theme.Colors.divider)
        )
    }

    private func saveRecipe() {
        let cleanIngredients = ingredients.compactMap { draft -> Ingredient? in
            let name = draft.name.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !name.isEmpty else { return nil }
            let quantity = [draft.quantity, draft.unit]
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
                .joined(separator: " ")
            return Ingredient(name: name, quantity: quantity.isEmpty ? "As needed" : quantity)
        }

        let cleanSteps = steps.enumerated().compactMap { index, draft -> RecipeStep? in
            let details = draft.description.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !details.isEmpty else { return nil }
            let title = draft.title.trimmingCharacters(in: .whitespacesAndNewlines)
            return RecipeStep(title: title.isEmpty ? "Step \(index + 1)" : title, description: details)
        }

        let recipe = Recipe(
            id: UUID(),
            name: title.trimmingCharacters(in: .whitespacesAndNewlines),
            imageURL: "",
            cookTimeMinutes: prepTime + cookTime,
            cuisine: selectedCourse,
            mealType: selectedMealTime,
            rating: 0,
            reviewCount: 0,
            servings: servings,
            ingredients: cleanIngredients,
            instructions: cleanSteps,
            authorUsername: authorUsername,
            isPublic: isPublic,
            isTrending: false,
            tags: [selectedCourse, selectedMealTime, description].filter { !$0.isEmpty }
        )

        onSave(recipe)
        dismiss()
    }
}

private struct DraftIngredient: Identifiable {
    let id = UUID()
    var quantity = ""
    var unit = ""
    var name = ""
}

private struct DraftStep: Identifiable {
    let id = UUID()
    var title = ""
    var description = ""
}

