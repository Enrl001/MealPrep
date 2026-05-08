//
//  FollowingTab.swift
//
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//

import SwiftUI

struct FollowingTab: View {
    let people: [ProfilePerson]

    var body: some View {
        LazyVStack(spacing: Theme.Spacing.md) {
            ForEach(people) { person in
                HStack(spacing: Theme.Spacing.md) {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Theme.Colors.primary.opacity(0.22), Theme.Colors.tertiary.opacity(0.12)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 58, height: 58)
                        .overlay {
                            Image(systemName: person.imageName)
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.white, Theme.Colors.primary.opacity(0.7))
                                .padding(7)
                        }

                    VStack(alignment: .leading, spacing: 3) {
                        Text(person.name)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(Theme.Colors.textPrimary)
                        Text(person.handle)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Theme.Colors.textSecondary)
                    }

                    Spacer()

                    Button("Following") {}
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Theme.Colors.primary)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Theme.Colors.primaryLight)
                        .clipShape(Capsule())
                        .buttonStyle(.plain)
                }
                .padding(.horizontal, Theme.Spacing.lg)
            }
        }
        .padding(.top, Theme.Spacing.lg)
    }
}

struct ProfileRecipeGrid: View {
    let recipes: [ProfileRecipe]

    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: Theme.Spacing.md),
                GridItem(.flexible(), spacing: Theme.Spacing.md)
            ],
            spacing: Theme.Spacing.md
        ) {
            ForEach(recipes) { recipe in
                VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                    ZStack(alignment: .topTrailing) {
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(recipe.background)
                            .aspectRatio(0.88, contentMode: .fit)
                            .overlay {
                                if UIImage(named: recipe.imageName) != nil {
                                    Image(recipe.imageName)
                                        .resizable()
                                        .scaledToFill()
                                } else {
                                    VStack {
                                        Spacer()
                                        Image(systemName: "fork.knife.circle.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 68, height: 68)
                                            .foregroundStyle(.white.opacity(0.92))
                                        Spacer()
                                    }
                                    .padding()
                                }
                            }
                            .clipped()

                        Image(systemName: "bookmark")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(Theme.Colors.primary)
                            .padding(9)
                            .background(.white.opacity(0.95))
                            .clipShape(Circle())
                            .padding(10)
                    }

                    Text(recipe.title)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(Theme.Colors.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(.horizontal, Theme.Spacing.md)
        .padding(.top, Theme.Spacing.lg)
    }
}
