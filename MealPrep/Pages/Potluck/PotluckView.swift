//
//  PotluckView.swift
//  
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//
import SwiftUI

struct PotluckView: View {
    @EnvironmentObject private var authVM: AuthViewModel
    @StateObject private var viewModel = PotluckViewModel()
    @State private var selectedTab: PotluckListTab = .upcoming
    @State private var authDestination: AuthDestination?
    @State private var isShowingCreateSheet = false

    private enum PotluckListTab: String, CaseIterable {
        case upcoming = "Upcoming"
        case past = "Past"
    }

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

    private var currentUser: User? {
        authVM.currentUser
    }

    private var displayedPotlucks: [PotluckEvent] {
        let now = Date()
        switch selectedTab {
        case .upcoming:
            return viewModel.potlucks.filter { $0.date >= now }
        case .past:
            return viewModel.potlucks.filter { $0.date < now }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                AppHeaderView()

                Divider()

                if currentUser == nil {
                    signedOutContent
                } else {
                    loggedInContent
                }
            }
            .background(Theme.Colors.surface)
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
            .environmentObject(authVM)
        }
        .sheet(isPresented: $isShowingCreateSheet) {
            CreatePotluckSheet(hostName: currentUser?.displayName ?? "Guest User") { potluck in
                viewModel.addPotluck(potluck)
            }
        }
        .onAppear {
            loadPotlucksIfNeeded()
        }
        .onChange(of: authVM.currentUser?.id) { _, userID in
            if userID != nil {
                authDestination = nil
            }
            loadPotlucksIfNeeded()
        }
    }

    private var loggedInContent: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: Theme.Spacing.md) {
                    tabSelector

                    if displayedPotlucks.isEmpty {
                        emptyLoggedInState
                    } else {
                        ForEach(displayedPotlucks) { potluck in
                            PotluckCard(potluck: potluck)
                        }
                    }
                }
                .padding(Theme.Spacing.md)
                .padding(.bottom, 88)
            }

            Button {
                isShowingCreateSheet = true
            } label: {
                Label("Create Potluck", systemImage: "plus")
                    .font(Theme.Typography.subhead)
                    .foregroundStyle(.white)
                    .padding(.horizontal, Theme.Spacing.lg)
                    .padding(.vertical, Theme.Spacing.md)
                    .background(Theme.Colors.tertiary)
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.18), radius: 8, x: 0, y: 4)
            }
            .padding(Theme.Spacing.md)
        }
    }

    private var tabSelector: some View {
        HStack(spacing: 0) {
            ForEach(PotluckListTab.allCases, id: \.self) { tab in
                Button {
                    selectedTab = tab
                } label: {
                    VStack(spacing: Theme.Spacing.sm) {
                        Text(tab.rawValue)
                            .font(Theme.Typography.caption)
                            .foregroundStyle(selectedTab == tab ? Theme.Colors.textPrimary : Theme.Colors.textSecondary)
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
    }

    private var emptyLoggedInState: some View {
        VStack(spacing: Theme.Spacing.sm) {
            Image(systemName: "calendar.badge.clock")
                .font(.system(size: Theme.IconSize.lg, weight: .semibold))
                .foregroundStyle(Theme.Colors.primary)

            Text(selectedTab == .upcoming ? "No upcoming potlucks" : "No past potlucks")
                .font(Theme.Typography.heading)
                .foregroundStyle(Theme.Colors.textPrimary)

            Text("Create a potluck to invite friends and organize a shared meal.")
                .font(Theme.Typography.body)
                .foregroundStyle(Theme.Colors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(Theme.Spacing.xl)
        .background(Theme.Colors.background)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.md)
                .stroke(Theme.Colors.divider)
        )
    }
    private var signedOutContent: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Theme.Spacing.lg) {
                communityHero
                emptyPotluckCard
                profileAuthButtons
            }
            .padding(Theme.Spacing.md)
        }
    }

    private var communityHero: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            ZStack(alignment: .bottomLeading) {
                Image("mealprep")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: 220)
                    .clipped()
                    .overlay(Color.black.opacity(0.24))

                VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                    Text("New Experience")
                        .font(Theme.Typography.micro)
                        .foregroundStyle(Theme.Colors.background)
                        .padding(.horizontal, Theme.Spacing.sm)
                        .padding(.vertical, Theme.Spacing.xs)
                        .background(Theme.Colors.primary)
                        .clipShape(Capsule())

                    Text("Cook, Share, and Connect")
                        .font(Theme.Typography.hero)
                        .foregroundStyle(.white)
                        .lineLimit(2)
                        .minimumScaleFactor(0.75)
                }
                .padding(Theme.Spacing.md)
            }
            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))

            Text("Join our local culinary community. Organize potlucks, discover hidden recipes, and build meaningful connections.")
                .font(Theme.Typography.body)
                .foregroundStyle(Theme.Colors.textSecondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .lineSpacing(3)
        }
    }

    private var profileAuthButtons: some View {
        VStack(spacing: Theme.Spacing.sm) {
            Button {
                authDestination = .login
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
                authDestination = .signUp
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

    private var emptyPotluckCard: some View {
        VStack(spacing: Theme.Spacing.md) {
            Image(systemName: "person.3.fill")
                .font(.system(size: Theme.IconSize.lg, weight: .semibold))
                .foregroundStyle(Theme.Colors.primary.opacity(0.35))

            VStack(spacing: Theme.Spacing.xs) {
                Text("Your first potluck awaits")
                    .font(Theme.Typography.heading)
                    .foregroundStyle(Theme.Colors.textPrimary)

                Text("You're not part of any potlucks yet. Sign in to find a group near you.")
                    .font(Theme.Typography.body)
                    .foregroundStyle(Theme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(Theme.Spacing.xl)
        .background(Theme.Colors.background)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.md)
                .stroke(Theme.Colors.divider, style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
        )
    }


    private func loadPotlucksIfNeeded() {
        guard let userID = currentUser?.id else { return }
        viewModel.load(for: userID)
    }
}
