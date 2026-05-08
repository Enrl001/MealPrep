//
//  ProfileView.swift
//
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//

import SwiftUI

struct ProfileView: View {
    @State private var viewModel = ProfileViewModel()

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    profileHeader
                    tabSelector
                    tabContent
                }
                .padding(.top, Theme.Spacing.lg)
                .padding(.bottom, Theme.Spacing.xl)
            }
            .background(Theme.Colors.background)
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var profileHeader: some View {
        VStack(spacing: Theme.Spacing.md) {
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Theme.Colors.primary.opacity(0.18),
                                Theme.Colors.tertiary.opacity(0.12)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 98, height: 98)
                    .overlay(
                        Circle()
                            .stroke(Theme.Colors.primary, lineWidth: 3)
                    )
                    .overlay {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.white, Theme.Colors.primary.opacity(0.65))
                            .padding(10)
                    }

//                Butdecdeyle(.plain)
            }

            Text(viewModel.profile.name)
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(Theme.Colors.textPrimary)

            HStack(spacing: Theme.Spacing.xl) {
                statView(value: viewModel.profile.recipeCount, title: "RECIPES")
                statView(value: viewModel.profile.followerCount, title: "FOLLOWERS")
                statView(value: viewModel.profile.followingCount, title: "FOLLOWING")
            }
        }
        .padding(.horizontal, Theme.Spacing.lg)
        .padding(.bottom, Theme.Spacing.lg)
    }

    private var tabSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Theme.Spacing.lg) {
                ForEach(ProfileTab.allCases) { tab in
                    Button {
                        viewModel.selectedTab = tab
                    } label: {
                        VStack(spacing: Theme.Spacing.sm) {
                            Text(tab.title)
                                .font(Theme.Typography.caption)
                                .foregroundStyle(
                                    viewModel.selectedTab == tab ? Theme.Colors.textPrimary : Theme.Colors.textSecondary
                                )
                                .multilineTextAlignment(.center)

                            Rectangle()
                                .fill(viewModel.selectedTab == tab ? Theme.Colors.primary : .clear)
                                .frame(height: 2)
                        }
                        .frame(minWidth: 56)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, Theme.Spacing.lg)
        }
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Theme.Colors.divider)
                .frame(height: 1)
        }
    }

    @ViewBuilder
    private var tabContent: some View {
        switch viewModel.selectedTab {
        case .saved:
            SavedRecipeTab(recipes: viewModel.savedRecipes)
        case .inventory:
            InventoryTab(recipes: viewModel.inventoryRecipes)
        case .myRecipes:
            MyRecipesTab(recipes: viewModel.myRecipes)
        case .followers:
            FollowersTab(people: viewModel.followers)
        case .following:
            FollowingTab(people: viewModel.following)
        }
    }

    private func statView(value: String, title: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(Theme.Typography.body)
                .foregroundStyle(Theme.Colors.primary)
            Text(title)
                .font(Theme.Typography.micro)
                .foregroundStyle(Theme.Colors.textSecondary)
                .tracking(0.4)
        }
    }
}
