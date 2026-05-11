//
//  ScheduleView.swift
//  
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//

import SwiftUI

struct ScheduleView: View {
    @EnvironmentObject private var appRouter: AppRouter
    @StateObject private var viewModel = ScheduleViewModel()
    @State private var showAddMealSheet = false
    @State private var recipeToSchedule: Recipe?

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.Colors.surface
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    headerView

                    ScrollView {
                        VStack(spacing: Theme.Spacing.lg) {
                            CalendarGridView(
                                events: viewModel.mealEvents,
                                days: viewModel.days,
                                dates: viewModel.dates,
                                times: viewModel.times
                            )

                            scheduledMealsView
                            progressView
                        }
                        .padding(.bottom, 90)
                    }
                }

                addButton
            }
            .sheet(isPresented: $showAddMealSheet, onDismiss: {
                recipeToSchedule = nil
                appRouter.clearRecipeToSchedule()
            }) {
                AddMealSheet(viewModel: viewModel, recipe: recipeToSchedule)
                    .environmentObject(appRouter)
            }
            .onChange(of: appRouter.recipeToSchedule?.id) { _, _ in
                presentRecipeToScheduleIfNeeded()
            }
            .onAppear {
                presentRecipeToScheduleIfNeeded()
            }
        }
    }

    private func presentRecipeToScheduleIfNeeded() {
        guard let recipe = appRouter.recipeToSchedule else { return }
        recipeToSchedule = recipe
        showAddMealSheet = true
    }

    private var headerView: some View {
        VStack(spacing: Theme.Spacing.md) {
            HStack {
                Circle()
                    .fill(Theme.Colors.primaryLight)
                    .frame(width: 48, height: 48)
                    .overlay(Text("👨‍🍳").font(.title2))

                Text("MealPrep")
                    .font(Theme.Typography.heading)
                    .foregroundColor(Theme.Colors.primary)

                Spacer()

                Image(systemName: "magnifyingglass")
                    .foregroundColor(Theme.Colors.textSecondary)

                Image(systemName: "bell")
                    .foregroundColor(Theme.Colors.textSecondary)
            }
            .padding(.horizontal, Theme.Spacing.md)

            WeekNavigatorView(
                weekLabel: viewModel.weekLabel,
                weekRange: viewModel.weekRange,
                onPreviousWeek: viewModel.moveToPreviousWeek,
                onNextWeek: viewModel.moveToNextWeek
            )
            .padding(.horizontal, Theme.Spacing.md)
        }
        .padding(.top, Theme.Spacing.md)
        .padding(.bottom, Theme.Spacing.sm)
        .background(Theme.Colors.background)
    }

    private var progressView: some View {
        VStack(spacing: Theme.Spacing.md) {
            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                HStack {
                    Text(viewModel.progressTitle)
                        .font(Theme.Typography.caption.bold())
                        .foregroundColor(Theme.Colors.textSecondary)

                    Spacer()

                    Text(viewModel.progressText)
                        .font(Theme.Typography.caption.bold())
                        .foregroundColor(Theme.Colors.textSecondary)
                }

                ProgressView(value: viewModel.progressValue)
                    .tint(Theme.Colors.primary)
            }
            .padding()
            .background(Theme.Colors.primaryLight.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.lg))

            HStack(spacing: Theme.Spacing.md) {
                ScheduleSummaryCard(
                    icon: "flame",
                    title: viewModel.dailyCalories,
                    subtitle: "Daily Cal Avg",
                    color: Theme.Colors.primary
                )

                ScheduleSummaryCard(
                    icon: "fork.knife",
                    title: viewModel.mealsPrepped,
                    subtitle: "Meals Prepped",
                    color: Theme.Colors.Meal.lunch
                )
            }
        }
        .padding(.horizontal, Theme.Spacing.md)
    }

    private var scheduledMealsView: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            HStack {
                Text("Scheduled Meals")
                    .font(Theme.Typography.subhead)
                    .foregroundColor(Theme.Colors.textPrimary)

                Spacer()

                Text("\(viewModel.mealEvents.count)")
                    .font(Theme.Typography.caption.bold())
                    .foregroundColor(Theme.Colors.primary)
            }

            if viewModel.mealEvents.isEmpty {
                Text("No meals planned for this week")
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Theme.Colors.background)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
            } else {
                VStack(spacing: Theme.Spacing.sm) {
                    ForEach(viewModel.mealEvents) { event in
                        ScheduledMealRow(event: event)
                    }
                }
            }
        }
        .padding(.horizontal, Theme.Spacing.md)
    }

    private var addButton: some View {
        VStack {
            Spacer()

            HStack {
                Spacer()

                Button {
                    recipeToSchedule = nil
                    showAddMealSheet = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .frame(width: 64, height: 64)
                        .background(Theme.Colors.primary)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.lg))
                        .shadow(radius: 4)
                }
                .padding(Theme.Spacing.lg)
            }
        }
    }
}

private struct ScheduledMealRow: View {
    let event: MealEvent

    private var ingredientsToShow: [Ingredient] {
        event.missingIngredients.isEmpty ? event.ingredients : event.missingIngredients
    }

    private var ingredientsTitle: String {
        event.missingIngredients.isEmpty ? "Ingredients" : "Needed Ingredients"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            HStack(alignment: .top, spacing: Theme.Spacing.sm) {
                if let recipe = event.recipe {
                    NavigationLink {
                        RecipeDetailView(recipe: recipe)
                    } label: {
                        recipeIcon(systemName: "book.pages")
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Open recipe")
                } else {
                    recipeIcon(systemName: "fork.knife")
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(event.recipeName)
                        .font(Theme.Typography.subhead)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .lineLimit(1)

                    Text("\(event.day) at \(event.time) • \(event.mealType.rawValue)")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                }

                Spacer()

                if event.recipe != nil {
                    Image(systemName: "chevron.right")
                        .font(.system(size: Theme.IconSize.sm, weight: .semibold))
                        .foregroundColor(Theme.Colors.textTertiary)
                        .padding(.top, Theme.Spacing.sm)
                }
            }

            if !ingredientsToShow.isEmpty {
                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    Text(ingredientsTitle)
                        .font(Theme.Typography.micro.bold())
                        .foregroundColor(event.missingIngredients.isEmpty ? Theme.Colors.textSecondary : Theme.Colors.tertiary)

                    FlowLayout(spacing: Theme.Spacing.xs) {
                        ForEach(ingredientsToShow, id: \.self) { ingredient in
                            Text("\(ingredient.quantity) \(ingredient.name)")
                                .font(Theme.Typography.micro)
                                .foregroundColor(event.missingIngredients.isEmpty ? Theme.Colors.textSecondary : Theme.Colors.tertiary)
                                .padding(.horizontal, Theme.Spacing.sm)
                                .padding(.vertical, Theme.Spacing.xs)
                                .background((event.missingIngredients.isEmpty ? Theme.Colors.surface : Theme.Colors.tertiaryLight).opacity(0.9))
                                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm))
                        }
                    }
                }
            }
        }
        .padding()
        .background(Theme.Colors.background)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.lg)
                .stroke(Theme.Colors.divider)
        )
    }

    private func recipeIcon(systemName: String) -> some View {
        Image(systemName: systemName)
            .font(.system(size: Theme.IconSize.sm, weight: .semibold))
            .foregroundColor(event.mealType.color)
            .frame(width: 36, height: 36)
            .background(event.mealType.lightColor)
            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm))
    }
}

private struct FlowLayout<Content: View>: View {
    let spacing: CGFloat
    @ViewBuilder let content: Content

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: spacing) {
                content
            }

            VStack(alignment: .leading, spacing: spacing) {
                content
            }
        }
    }
}

private struct ScheduleSummaryCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color

    var body: some View {
        HStack(spacing: Theme.Spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: Theme.IconSize.md, weight: .semibold))
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.15))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                Text(title)
                    .font(Theme.Typography.subhead)
                    .foregroundColor(Theme.Colors.textPrimary)

                Text(subtitle)
                    .font(Theme.Typography.caption)
                    .foregroundColor(Theme.Colors.textSecondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }

            Spacer(minLength: 0)
        }
        .padding(Theme.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.Colors.background)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.lg)
                .stroke(Theme.Colors.divider)
        )
    }
}
