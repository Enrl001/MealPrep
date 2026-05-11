//
//  ProfileView.swift
//
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//

import SwiftUI

struct ProfileView: View {
    @State private var selectedTab: ProfileTab = .saved
    @State private var showAuthPopup = false
    @State private var currentUser: User?
    @State private var authDestination: AuthDestination?
    @Environment(UserLibrary.self) private var userLibrary
    @State private var selectedRecipe: Recipe?
    @EnvironmentObject private var authViewModel: AuthViewModel

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
            VStack(spacing: 0) {
                AppHeaderView()

                Divider()

                if currentUser == nil && authViewModel.currentUser == nil {
                    signedOutProfileView
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            profileHeader
                            tabSelector
                            tabContent
                        }
                        .padding(.top, Theme.Spacing.lg)
                        .padding(.bottom, Theme.Spacing.xl)
                    }
                }
            }
            .background(Theme.Colors.background)
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(item: $selectedRecipe) { recipe in
                RecipeDetailView(recipe: recipe)
            }
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
            .environment(userLibrary)
        }
        .onAppear {
            currentUser = authViewModel.currentUser
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
        guard let user = currentUser ?? authViewModel.currentUser else {
            return "Guest User"
        }

        if let name = user.name?.trimmingCharacters(in: .whitespacesAndNewlines), !name.isEmpty {
            return name
        }

        return user.username.components(separatedBy: "@").first ?? user.username
    }

    private var profileRecipeCount: String {
        guard let userID = (currentUser ?? authViewModel.currentUser)?.id else { return "0" }
        return "\(loadRecipes(for: userID).count)"
    }

    private var profileSavedCount: String {
        "\(userLibrary.likedRecipes.count)"
    }

    private var profileFollowingCount: String {
        "\(userLibrary.followedBloggers.count)"
    }

    private var signedOutProfileView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Theme.Spacing.lg) {
                guestProfileCard
                culinaryIdentityCard
                profileAuthButtons
            }
            .padding(Theme.Spacing.md)
        }
        .background(Theme.Colors.surface)
    }

    private var guestProfileCard: some View {
        VStack(spacing: Theme.Spacing.sm) {
            Circle()
                .fill(Theme.Colors.background)
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

            Text("Guest User")
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(Theme.Colors.textPrimary)

            Text("Sign in to personalize your profile")
                .font(Theme.Typography.body)
                .foregroundStyle(Theme.Colors.textSecondary)
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

    private var culinaryIdentityCard: some View {
        VStack(spacing: Theme.Spacing.md) {
            Image(systemName: "book")
                .font(.system(size: Theme.IconSize.lg, weight: .semibold))
                .foregroundStyle(Theme.Colors.primary)
                .frame(width: 64, height: 64)
                .background(Theme.Colors.primaryLight)
                .clipShape(Circle())

            VStack(spacing: Theme.Spacing.sm) {
                Text("Your Culinary Identity")
                    .font(Theme.Typography.heading)
                    .foregroundStyle(Theme.Colors.textPrimary)
                    .multilineTextAlignment(.center)

                Text("Sign in to save recipes, track your inventory, and build your cooking legacy.")
                    .font(Theme.Typography.body)
                    .foregroundStyle(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
            }
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

    private var profileAuthButtons: some View {
        VStack(spacing: Theme.Spacing.sm) {
            Button {
                showAuthDestination(.login)
            } label: {
                Text("Login")
                    .font(Theme.Typography.subhead)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Theme.Spacing.md)
                    .background(Theme.Colors.primary)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
            }

            Button {
                showAuthDestination(.signUp)
            } label: {
                Text("Sign Up")
                    .font(Theme.Typography.subhead)
                    .foregroundStyle(Theme.Colors.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Theme.Spacing.md)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.Radius.md)
                            .stroke(Theme.Colors.primary, lineWidth: 1)
                    )
            }
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
            }

            Text(profileDisplayName)
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(Theme.Colors.textPrimary)

            HStack(spacing: Theme.Spacing.xl) {
                statView(value: profileRecipeCount, title: "RECIPES")
                statView(value: profileSavedCount, title: "SAVED")
                statView(value: profileFollowingCount, title: "FOLLOWING")
            }
        }
        .padding(.horizontal, Theme.Spacing.lg)
        .padding(.bottom, Theme.Spacing.lg)
    }

    private var tabSelector: some View {
        HStack(spacing: 0) {
            ForEach(ProfileTab.allCases) { tab in
                Button {
                    selectedTab = tab
                } label: {
                    VStack(spacing: Theme.Spacing.sm) {
                        Text(tab.title)
                            .font(Theme.Typography.caption)
                            .foregroundStyle(
                                selectedTab == tab ? Theme.Colors.textPrimary : Theme.Colors.textSecondary
                            )
                            .lineLimit(1)
                            .minimumScaleFactor(0.85)

                        Rectangle()
                            .fill(selectedTab == tab ? Theme.Colors.primary : .clear)
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
            .environment(userLibrary)
        }
    }

    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case .saved:
            SavedRecipeTab { recipe in
                selectedRecipe = recipe
            }
        case .inventory:
            InventoryTab()
        case .myRecipes:
            MyRecipesTab { recipe in
                selectedRecipe = recipe
            }
        case .followers:
            FollowersTab(people: [])
        case .following:
            FollowingTab()
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
