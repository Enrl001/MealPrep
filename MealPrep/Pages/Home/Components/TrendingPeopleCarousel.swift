//
//  TrendingPeopleCarousel.swift
//  
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//

import SwiftUI

struct TrendingPeopleCarousel: View {
    let bloggers: [Blogger]
    @State private var showTrendingPeople = false

    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            
            // MARK: - Section Header
            HStack {
                Text("Trending Food Bloggers")
                    .font(Theme.Typography.heading)
                    .foregroundStyle(Theme.Colors.textPrimary)
                
                Spacer()
                
                Button("See all →") {
                    showTrendingPeople = true
                }
                .font(Theme.Typography.body)
                .foregroundStyle(Theme.Colors.primary)
            }
            .padding(.horizontal, Theme.Spacing.md)
            
            // MARK: - Horizontal Scroll
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Theme.Spacing.lg) {
                    ForEach(bloggers) { blogger in
                        VStack(spacing: Theme.Spacing.xs) {
                            
                            // Avatar circle
                            AsyncImage(url: URL(string: blogger.imageURL)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Circle()
                                    .fill(Theme.Colors.surface)
                                    .overlay {
                                        Image(systemName: "person.fill")
                                            .foregroundStyle(Theme.Colors.textTertiary)
                                            .font(.system(size: 24))
                                    }
                            }
                            .frame(width: 64, height: 64)
                            .clipShape(Circle())
                            .overlay {
                                Circle()
                                    .stroke(Theme.Colors.divider, lineWidth: 1)
                            }
                            
                            // Name
                            Text(blogger.name)
                                .font(Theme.Typography.micro)
                                .foregroundStyle(Theme.Colors.textPrimary)
                                .lineLimit(1)
                        }
                        .frame(width: 70)
                    }
                }
                .padding(.horizontal, Theme.Spacing.md)
            }
        }
        .navigationDestination(isPresented: $showTrendingPeople) {
            TrendingPeoplePage()
        }
    }
}

#Preview {
    TrendingPeopleCarousel(bloggers: BloggerMockData.bloggers)
        .padding(.vertical)
}
