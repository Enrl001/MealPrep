//
//  ScheduleView.swift
//  
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//

import SwiftUI

struct ScheduleView: View {
    @StateObject private var viewModel = ScheduleViewModel()
    @State private var showAddMealSheet = false

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

                            progressView
                        }
                        .padding(.bottom, 90)
                    }
                }

                addButton
            }
            .sheet(isPresented: $showAddMealSheet) {
                AddMealSheet(viewModel: viewModel)
            }
        }
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
                weekRange: viewModel.weekRange
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

    private var addButton: some View {
        VStack {
            Spacer()

            HStack {
                Spacer()

                Button {
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

