//
//  TrendingPeoplePage.swift
//  
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//

import SwiftUI

struct TrendingPeoplePage: View {
    @State private var searchText = ""
    @State private var selectedFilter = "All Creators"
    
    let filters = ["All Creators", "Vegan Expert", "Pastry Chef", "Meal Prep"]
    
    var filteredBloggers: [Blogger] {
        if selectedFilter == "All Creators" {
            return BloggerMockData.bloggers
        }
        return BloggerMockData.bloggers.filter {
            $0.specialties.contains(selectedFilter)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: - Search Bar
            SearchBarView(searchText: $searchText)
                .padding(.horizontal, Theme.Spacing.md)
                .padding(.vertical, Theme.Spacing.sm)
            
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                    
                    // MARK: - Header
                    VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                        Text("Trending People")
                            .font(Theme.Typography.hero)
                            .foregroundStyle(Theme.Colors.textPrimary)
                        Text("Discover the most inspiring culinary creators this week.")
                            .font(Theme.Typography.body)
                            .foregroundStyle(Theme.Colors.textSecondary)
                    }
                    .padding(.horizontal, Theme.Spacing.md)
                    
                    // MARK: - Filter Chips
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: Theme.Spacing.sm) {
                            ForEach(filters, id: \.self) { filter in
                                Button {
                                    selectedFilter = filter
                                } label: {
                                    Text(filter)
                                        .font(Theme.Typography.body)
                                        .foregroundStyle(
                                            selectedFilter == filter
                                            ? Theme.Colors.background
                                            : Theme.Colors.textSecondary
                                        )
                                        .padding(.horizontal, Theme.Spacing.md)
                                        .padding(.vertical, Theme.Spacing.xs)
                                        .background(
                                            selectedFilter == filter
                                            ? Theme.Colors.primary
                                            : Theme.Colors.background
                                        )
                                        .clipShape(Capsule())
                                        .overlay {
                                            if selectedFilter != filter {
                                                Capsule()
                                                    .stroke(Theme.Colors.divider, lineWidth: 1.5)
                                            }
                                        }
                                }
                            }
                        }
                        .padding(.horizontal, Theme.Spacing.md)
                    }
                    
                    // MARK: - Blogger Cards
                    VStack(spacing: Theme.Spacing.md) {
                        ForEach(filteredBloggers) { blogger in
                            BloggerFullCard(blogger: blogger)
                                .padding(.horizontal, Theme.Spacing.md)
                        }
                    }
                }
                .padding(.vertical, Theme.Spacing.md)
            }
        }
        .background(Theme.Colors.background)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Full Blogger Card
struct BloggerFullCard: View {
    let blogger: Blogger
    @State private var isFollowing = false
    
    var followersText: String {
        if blogger.followers >= 1000 {
            return "\(blogger.followers / 1000)k"
        }
        return "\(blogger.followers)"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            // Image
            ZStack(alignment: .topLeading) {
                AsyncImage(url: URL(string: blogger.imageURL)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Rectangle()
                        .fill(Theme.Colors.surface)
                        .overlay {
                            Image(systemName: "person.fill")
                                .foregroundStyle(Theme.Colors.textTertiary)
                                .font(.system(size: 40))
                        }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 180)
                .clipped()
                
                // Top Trending badge
                Text("Top Trending")
                    .font(Theme.Typography.micro)
                    .foregroundStyle(Theme.Colors.background)
                    .padding(.horizontal, Theme.Spacing.sm)
                    .padding(.vertical, 4)
                    .background(Theme.Colors.tertiary)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm))
                    .padding(Theme.Spacing.sm)
            }
            
            // Info
            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                
                // Name + followers
                HStack {
                    Text(blogger.name)
                        .font(Theme.Typography.heading)
                        .foregroundStyle(Theme.Colors.textPrimary)
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "person.2.fill")
                            .font(.system(size: 11))
                            .foregroundStyle(Theme.Colors.textSecondary)
                        Text(followersText)
                            .font(Theme.Typography.micro)
                            .foregroundStyle(Theme.Colors.textSecondary)
                    }
                }
                
                // Bio
                Text(blogger.bio)
                    .font(Theme.Typography.body)
                    .foregroundStyle(Theme.Colors.textSecondary)
                    .lineLimit(3)
                
                // Specialty tags
                HStack(spacing: Theme.Spacing.xs) {
                    ForEach(blogger.specialties, id: \.self) { specialty in
                        Text(specialty)
                            .font(Theme.Typography.micro)
                            .foregroundStyle(Theme.Colors.primary)
                            .padding(.horizontal, Theme.Spacing.sm)
                            .padding(.vertical, 3)
                            .background(Theme.Colors.primaryLight)
                            .clipShape(Capsule())
                    }
                }
                
                // Follow button
                Button {
                    isFollowing.toggle()
                } label: {
                    Text(isFollowing ? "Following" : "Follow")
                        .font(Theme.Typography.subhead)
                        .foregroundStyle(isFollowing ? Theme.Colors.primary : Theme.Colors.background)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Theme.Spacing.sm)
                        .background(isFollowing ? Theme.Colors.background : Theme.Colors.primary)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.pill))
                        .overlay {
                            if isFollowing {
                                RoundedRectangle(cornerRadius: Theme.Radius.pill)
                                    .stroke(Theme.Colors.primary, lineWidth: 1.5)
                            }
                        }
                }
            }
            .padding(Theme.Spacing.md)
        }
        .background(Theme.Colors.background)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
        .overlay {
            RoundedRectangle(cornerRadius: Theme.Radius.md)
                .stroke(Theme.Colors.divider, lineWidth: 1)
        }
    }
}

#Preview {
    NavigationStack {
        TrendingPeoplePage()
    }
}
