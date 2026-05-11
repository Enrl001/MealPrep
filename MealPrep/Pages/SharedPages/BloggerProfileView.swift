//
//  BloggerProfileView.swift
//  
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//

import SwiftUI

struct BloggerProfileView: View {
    let blogger: Blogger
    @Environment(UserLibrary.self) private var userLibrary
    @EnvironmentObject var authVM: AuthViewModel
    @State private var showGuestGate = false
    @Environment(\.dismiss) private var dismiss
    
    var followersText: String {
        if blogger.followers >= 1000 {
            return "\(blogger.followers / 1000).0k"
        }
        return "\(blogger.followers)"
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                
                // MARK: - Cover + Avatar
                ZStack(alignment: .bottomLeading) {
                    // Cover image
                    AsyncImage(url: URL(string: blogger.imageURL)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Rectangle()
                            .fill(Theme.Colors.surface)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 160)
                    .clipped()
                    
                    // Avatar
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
                                    .font(.system(size: 30))
                            }
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .overlay {
                        Circle()
                            .stroke(Theme.Colors.background, lineWidth: 3)
                    }
                    .offset(x: Theme.Spacing.md, y: 40)
                }
                .frame(height: 160)
                
                // MARK: - Profile Info
                VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                    
                    // Name + Follow button
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(blogger.name)
                                .font(Theme.Typography.hero)
                                .foregroundStyle(Theme.Colors.textPrimary)
                            Text(blogger.specialties.joined(separator: " & "))
                                .font(Theme.Typography.micro)
                                .foregroundStyle(Theme.Colors.textSecondary)
                        }
                        
                        Spacer()
                        
                        Button {
                            if authVM.currentUser != nil {
                                userLibrary.toggleFollow(for: blogger)
                            } else {
                                showGuestGate = true
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: userLibrary.isFollowing(blogger) ? "checkmark" : "person.badge.plus")
                                    .font(.system(size: 12))
                                Text(userLibrary.isFollowing(blogger) ? "Following" : "Follow")
                                    .font(Theme.Typography.caption)
                            }
                            .foregroundStyle(userLibrary.isFollowing(blogger) ? Theme.Colors.primary : Theme.Colors.background)
                            .padding(.horizontal, Theme.Spacing.md)
                            .padding(.vertical, Theme.Spacing.xs)
                            .background(userLibrary.isFollowing(blogger) ? Theme.Colors.background : Theme.Colors.primary)
                            .clipShape(Capsule())
                            .overlay {
                                if userLibrary.isFollowing(blogger) {
                                    Capsule()
                                        .stroke(Theme.Colors.primary, lineWidth: 1.5)
                                }
                            }
                        }
                        .sheet(isPresented: $showGuestGate) {
                            GuestGateView(action: "follow bloggers", isPresented: $showGuestGate)
                                .presentationDetents([.medium])
                                .environmentObject(authVM)
                        }
                    }
                    .padding(.top, 48)
                    
                    // MARK: - Stats
                    HStack(spacing: Theme.Spacing.xl) {
                        StatItem(value: "\(blogger.recipeCount)", label: "Recipes")
                        StatItem(value: followersText, label: "Followers")
                        StatItem(value: "\(blogger.following)", label: "Following")
                    }
                    
                    // MARK: - Bio
                    Text(blogger.bio)
                        .font(Theme.Typography.body)
                        .foregroundStyle(Theme.Colors.textSecondary)
                        .lineSpacing(4)
                    
                    // MARK: - Specialty Tags
                    HStack(spacing: Theme.Spacing.xs) {
                        ForEach(blogger.specialties, id: \.self) { specialty in
                            Text("#\(specialty.replacingOccurrences(of: " ", with: ""))")
                                .font(Theme.Typography.micro)
                                .foregroundStyle(Theme.Colors.primary)
                                .padding(.horizontal, Theme.Spacing.sm)
                                .padding(.vertical, 3)
                                .background(Theme.Colors.primaryLight)
                                .clipShape(Capsule())
                        }
                    }
                    
                    Divider()
                    
                    // MARK: - Recipes Tab Header
                    Text("Recipes")
                        .font(Theme.Typography.subhead)
                        .foregroundStyle(Theme.Colors.primary)
                        .padding(.bottom, 4)
                        .overlay(alignment: .bottom) {
                            Rectangle()
                                .fill(Theme.Colors.primary)
                                .frame(height: 2)
                        }
                    
                    // MARK: - Recipe Cards
                    VStack(spacing: Theme.Spacing.md) {
                        ForEach(MockRecipes.all.filter { $0.authorUsername == blogger.name }) { recipe in
                            NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                BloggerRecipeRow(recipe: recipe)
                            }
                        }
                        
                        // Show some recipes if no matching ones found
                        if MockRecipes.all.filter({ $0.authorUsername == blogger.name }).isEmpty {
                            ForEach(MockRecipes.all.prefix(3)) { recipe in
                                NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                                    BloggerRecipeRow(recipe: recipe)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, Theme.Spacing.md)
                .padding(.bottom, Theme.Spacing.lg)
            }
        }
        .background(Theme.Colors.background)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ShareLink(
                        item: URL(string: "mealprepapp://blogger/\(blogger.id)") ?? URL(string: "https://mealprep.app")!,
                        subject: Text(blogger.name),
                        message: Text("Check out \(blogger.name) on MealPrep!")
                    ) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundStyle(Theme.Colors.textPrimary)
                    }
            }
        }
    }
}

// MARK: - Stat Item
struct StatItem: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(Theme.Typography.heading)
                .foregroundStyle(Theme.Colors.textPrimary)
            Text(label)
                .font(Theme.Typography.micro)
                .foregroundStyle(Theme.Colors.textSecondary)
        }
    }
}

// MARK: - Blogger Recipe Row
struct BloggerRecipeRow: View {
    let recipe: Recipe
    
    var body: some View {
        HStack(spacing: Theme.Spacing.sm) {
            AsyncImage(url: URL(string: recipe.imageURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Rectangle()
                    .fill(Theme.Colors.surface)
            }
            .frame(width: 80, height: 80)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm))
            
            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                Text(recipe.name)
                    .font(Theme.Typography.subhead)
                    .foregroundStyle(Theme.Colors.textPrimary)
                    .lineLimit(2)
                
                HStack(spacing: Theme.Spacing.xs) {
                    Image(systemName: "clock")
                        .font(.system(size: 11))
                        .foregroundStyle(Theme.Colors.textSecondary)
                    Text("\(recipe.cookTimeMinutes) min")
                        .font(Theme.Typography.micro)
                        .foregroundStyle(Theme.Colors.textSecondary)
                    Text("•")
                        .foregroundStyle(Theme.Colors.textTertiary)
                    Text(recipe.mealType.lowercased().capitalized)
                        .font(Theme.Typography.micro)
                        .foregroundStyle(Theme.Colors.textSecondary)
                }
                
                HStack(spacing: Theme.Spacing.xs) {
                    ForEach(recipe.tags.prefix(2), id: \.self) { tag in
                        Text(tag)
                            .font(Theme.Typography.micro)
                            .foregroundStyle(Theme.Colors.primary)
                            .padding(.horizontal, Theme.Spacing.xs)
                            .padding(.vertical, 2)
                            .background(Theme.Colors.primaryLight)
                            .clipShape(Capsule())
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "heart")
                .foregroundStyle(Theme.Colors.textSecondary)
        }
        .padding(Theme.Spacing.sm)
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
        BloggerProfileView(blogger: BloggerMockData.bloggers[0])
            .environmentObject(AuthViewModel())
            .environment(UserLibrary.shared)
    }
}
