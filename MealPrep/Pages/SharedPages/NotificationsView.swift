//
//  NotificationsView.swift
//  MealPrep
//
//  Created by Hline Nadi Khant on 11/5/2026.
//

import SwiftUI

struct Notification: Identifiable {
    let id: UUID
    let title: String
    let message: String
    let time: String
    let type: NotificationType
    var isRead: Bool = false
}

enum NotificationType {
    case newRecipe, follow, trending, system
}

struct MockNotifications {
    static let all: [Notification] = [
        Notification(id: UUID(), title: "New Trending Recipe", message: "Creamy Basil Pesto Linguine is trending in your area!", time: "2m ago", type: .trending),
        Notification(id: UUID(), title: "Chef Julia posted", message: "Chef Julia just posted a new recipe: Summer Greek Salad Bowl", time: "15m ago", type: .newRecipe),
        Notification(id: UUID(), title: "New Follower", message: "Mark Bittman started following you", time: "1h ago", type: .follow),
        Notification(id: UUID(), title: "Recipe Saved", message: "Your recipe Avocado Toast has been saved 10 times!", time: "2h ago", type: .newRecipe),
        Notification(id: UUID(), title: "Trending Now", message: "Mediterranean Hummus Bowl is trending this week", time: "3h ago", type: .trending),
        Notification(id: UUID(), title: "New Follower", message: "Elena S. started following you", time: "5h ago", type: .follow),
        Notification(id: UUID(), title: "Weekly Summary", message: "You cooked 3 recipes this week. Keep it up!", time: "1d ago", type: .system),
        Notification(id: UUID(), title: "Chef Julia posted", message: "Chef Julia just posted: Honey Glazed Salmon Quinoa", time: "1d ago", type: .newRecipe),
    ]
}

struct NotificationsView: View {
    @State private var notifications = MockNotifications.all
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: - Header
            HStack {
                Text("Notifications")
                    .font(Theme.Typography.hero)
                    .foregroundStyle(Theme.Colors.textPrimary)
                
                Spacer()
                
            }
            .padding(.horizontal, Theme.Spacing.md)
            .padding(.vertical, Theme.Spacing.sm)
            
            Divider()
            
            // MARK: - Notifications List
            List {
                ForEach(notifications) { notification in
                    NotificationRow(notification: notification)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .listRowSeparator(.hidden)
                        .listRowBackground(
                            notification.isRead
                            ? Theme.Colors.background
                            : Theme.Colors.primaryLight.opacity(0.3)
                        )
                        .onTapGesture {
                            if let index = notifications.firstIndex(where: { $0.id == notification.id }) {
                                notifications[index].isRead = true
                            }
                        }
                }
            }
            .listStyle(.plain)
        }
        .background(Theme.Colors.background)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Notification Row
struct NotificationRow: View {
    let notification: Notification
    
    var iconName: String {
        switch notification.type {
        case .newRecipe: return "fork.knife.circle.fill"
        case .follow: return "person.circle.fill"
        case .trending: return "flame.circle.fill"
        case .system: return "bell.circle.fill"
        }
    }
    
    var iconColor: Color {
        switch notification.type {
        case .newRecipe: return Theme.Colors.primary
        case .follow: return Theme.Colors.tertiary
        case .trending: return Theme.Colors.primary
        case .system: return Theme.Colors.textSecondary
        }
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: Theme.Spacing.sm) {
            
            // Icon
            Image(systemName: iconName)
                .foregroundStyle(iconColor)
                .font(.system(size: 36))
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(notification.title)
                        .font(Theme.Typography.subhead)
                        .foregroundStyle(Theme.Colors.textPrimary)
                    Spacer()
                    Text(notification.time)
                        .font(Theme.Typography.micro)
                        .foregroundStyle(Theme.Colors.textTertiary)
                }
                
                Text(notification.message)
                    .font(Theme.Typography.body)
                    .foregroundStyle(Theme.Colors.textSecondary)
                    .lineLimit(2)
            }
            
            // Unread dot
            if !notification.isRead {
                Circle()
                    .fill(Theme.Colors.primary)
                    .frame(width: 8, height: 8)
                    .padding(.top, 4)
            }
        }
        .padding(.vertical, Theme.Spacing.xs)
    }
}

#Preview {
    NavigationStack {
        NotificationsView()
    }
}
