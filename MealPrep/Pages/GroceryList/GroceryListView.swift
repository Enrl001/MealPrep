//
//  GroceryListView.swift
//  
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//

import Foundation
import SwiftUI

struct GroceryListView: View {
    @StateObject private var viewModel = GroceryListViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                AppHeaderView()

                Divider()

                ZStack {
                    Theme.Colors.surface
                        .ignoresSafeArea()

                    ScrollView {
                        VStack(spacing: Theme.Spacing.lg) {
                            WeekNavigatorView(
                                weekLabel: viewModel.weekLabel,
                                weekRange: viewModel.weekRange,
                                onPreviousWeek: viewModel.moveToPreviousWeek,
                                onNextWeek: viewModel.moveToNextWeek
                            )

                            summaryView

                            if viewModel.groupedItems.isEmpty {
                                emptyWeekView
                            } else {
                                ForEach(viewModel.groupedItems, id: \.category) { section in
                                    GroceryChecklistSection(
                                        section: section,
                                        onToggle: viewModel.toggle
                                    )
                                }
                            }
                        }
                        .padding(Theme.Spacing.md)
                        .padding(.bottom, 80)
                    }

                    addButton
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .onAppear {
            viewModel.reloadCurrentWeek()
        }
    }

    private var boughtCountText: String {
        "\(viewModel.items.filter(\.isChecked).count)/\(viewModel.items.count)"
    }

    private var estimatedTotalText: String {
        "$0.00"
    }

    private var headerView: some View {
        HStack {
            Circle()
                .fill(Theme.Colors.primaryLight)
                .frame(width: 48, height: 48)
                .overlay(Text("👨‍🍳").font(.title2))

            Text("MealPrep")
                .font(Theme.Typography.heading)
                .foregroundColor(Theme.Colors.primary)

            Spacer()

            Image(systemName: "bell")
                .foregroundColor(Theme.Colors.textSecondary)
        }
    }

    private var summaryView: some View {
        HStack(spacing: Theme.Spacing.md) {
            SummaryCard(
                icon: "basket",
                title: boughtCountText,
                subtitle: "Items Bought",
                color: Theme.Colors.primary
            )

            SummaryCard(
                icon: "banknote",
                title: estimatedTotalText,
                subtitle: "Estimated Total",
                color: Theme.Colors.Meal.lunch
            )
        }
    }

    private var emptyWeekView: some View {
        VStack(spacing: Theme.Spacing.sm) {
            Image(systemName: "basket")
                .font(.system(size: Theme.IconSize.lg, weight: .semibold))
                .foregroundColor(Theme.Colors.textTertiary)

            Text("No grocery items for this week")
                .font(Theme.Typography.subhead)
                .foregroundColor(Theme.Colors.textPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding(Theme.Spacing.xl)
        .background(Theme.Colors.background)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.lg)
                .stroke(Theme.Colors.divider)
        )
    }

    private var addButton: some View {
        VStack {
            Spacer()

            HStack {
                Spacer()

                Button {
                    // Add item feature can be added later
                } label: {
                    Image(systemName: "plus")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .frame(width: 58, height: 58)
                        .background(Theme.Colors.primary)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                .padding(Theme.Spacing.lg)
            }
        }
    }
}
private struct SummaryCard: View {
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
