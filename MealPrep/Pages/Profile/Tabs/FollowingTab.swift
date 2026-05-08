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

