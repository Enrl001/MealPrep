//
//  FollowingTab.swift
//
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//

import SwiftUI

struct FollowingTab: View {
    @Environment(UserLibrary.self) private var userLibrary
    
    var body: some View {
        if userLibrary.followedBloggers.isEmpty {
            VStack(spacing: Theme.Spacing.md) {
                Image(systemName: "person.slash")
                    .font(.system(size: 40))
                    .foregroundStyle(Theme.Colors.textTertiary)
                Text("Not following anyone yet")
                    .font(Theme.Typography.heading)
                    .foregroundStyle(Theme.Colors.textPrimary)
                Text("Follow bloggers to see them here")
                    .font(Theme.Typography.body)
                    .foregroundStyle(Theme.Colors.textSecondary)
            }
            .padding(.top, Theme.Spacing.xl)
        } else {
            LazyVStack(spacing: Theme.Spacing.md) {
                ForEach(userLibrary.followedBloggers) { blogger in
                    HStack(spacing: Theme.Spacing.md) {
                        AsyncImage(url: URL(string: blogger.imageURL)) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            Circle()
                                .fill(Theme.Colors.surface)
                                .overlay {
                                    Image(systemName: "person.fill")
                                        .foregroundStyle(Theme.Colors.textTertiary)
                                }
                        }
                        .frame(width: 58, height: 58)
                        .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 3) {
                            Text(blogger.name)
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(Theme.Colors.textPrimary)
                            Text(blogger.specialties.first ?? "")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(Theme.Colors.textSecondary)
                        }
                        
                        Spacer()
                        
                        Button {
                            userLibrary.toggleFollow(for: blogger)
                        } label: {
                            Text("Following")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Theme.Colors.primary)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 10)
                                .background(Theme.Colors.primaryLight)
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, Theme.Spacing.lg)
                }
            }
            .padding(.top, Theme.Spacing.lg)
        }
    }
}
