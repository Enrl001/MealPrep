//
//  ProfileView.swift
//
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//

import SwiftUI

struct ProfileView: View {
    @State private var viewModel = ProfileViewModel()
    @State private var showAuthPopup = false
    @State private var currentUser: User?
    @State private var authDestination: AuthDestination?
    @StateObject private var authViewModel = AuthViewModel()

    private enum AuthDestination: Identifiable {
        case login
        case signUp

        var id: String {
            switch self {
            case .login:
                "login"
            case .signUp:
                "signUp"
            }
        }
    }

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
        .sheet(item: $authDestination) { destination in
            NavigationStack {
                switch destination {
                case .login:
                    LoginView {
                        authDestination = .signUp
                    }
                case .signUp:
                    SignupView {
                        authDestination = .login
                    }
                }
            }
            .environmentObject(authViewModel)
        }
        .onChange(of: authViewModel.currentUser?.id) { _, _ in
            currentUser = authViewModel.currentUser
            if currentUser != nil {
                authDestination = nil
                showAuthPopup = false
            }
        }
    }

    private var profileDisplayName: String {
        currentUser?.displayName ?? authViewModel.currentUser?.displayName ?? viewModel.profile.name
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
            }

            Text(profileDisplayName)
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
        HStack(spacing: 0) {
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
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)

                        Rectangle()
                            .fill(viewModel.selectedTab == tab ? Theme.Colors.primary : .clear)
                            .frame(height: 2)
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
            }
        }
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Theme.Colors.divider)
                .frame(height: 1)
        }
        .onAppear {
            currentUser = authViewModel.currentUser
            if currentUser == nil && !authViewModel.hasContinuedAsGuest {
                showAuthPopup = true
            }
        }
        .sheet(isPresented: $showAuthPopup) {
            AuthPopupView(
                showPopup: $showAuthPopup,
                onLoginTap: {
                    showAuthDestination(.login)
                },
                onSignUpTap: {
                    showAuthDestination(.signUp)
                },
                onGuestTap: {
                    authViewModel.continueAsGuest()
                }
            )
        }
    }

    @ViewBuilder
    private var tabContent: some View {
        switch viewModel.selectedTab {
        case .saved:
            SavedRecipeTab(recipes: MockRecipes.all)
        case .inventory:
            InventoryTab()
        case .myRecipes:
            MyRecipesTab()
        case .followers:
            FollowersTab(people: viewModel.followers)
        case .following:
            FollowingTab(people: viewModel.following)
        }
    }

    private func showAuthDestination(_ destination: AuthDestination) {
        showAuthPopup = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            authDestination = destination
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
