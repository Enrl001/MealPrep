//
//  NotificationsView.swift
//  MealPrep
//
//  Created by Hline Nadi Khant on 11/5/2026.
//

import Combine
import SwiftUI

struct Notification: Identifiable, Codable {
    let id: UUID
    let title: String
    let message: String
    let time: String
    let type: NotificationType
    var isRead: Bool = false
}

enum NotificationType: Codable {
    case newRecipe, follow, trending, system, missingIngredients
}

final class NotificationStore: ObservableObject {
    static let shared = NotificationStore()

    @Published private(set) var notifications: [Notification] = []

    private let notificationsKey = "notifications"

    private init() {
        load()
    }

    func addMissingIngredientsNotification(recipeName: String, missingIngredients: [Ingredient]) {
        guard !missingIngredients.isEmpty else { return }

        let list = missingIngredients
            .map { "\($0.quantity) \($0.name)" }
            .joined(separator: ", ")

        let notification = Notification(
            id: UUID(),
            title: "Missing Ingredients",
            message: "\(recipeName) needs: \(list)",
            time: "Just now",
            type: .missingIngredients
        )

        notifications.insert(notification, at: 0)
        save()
    }

    func markAsRead(_ notification: Notification) {
        guard let index = notifications.firstIndex(where: { $0.id == notification.id }) else {
            return
        }

        notifications[index].isRead = true
        save()
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: notificationsKey),
              let savedNotifications = try? JSONDecoder().decode([Notification].self, from: data) else {
            notifications = []
            return
        }

        notifications = savedNotifications
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(notifications) else {
            return
        }

        UserDefaults.standard.set(data, forKey: notificationsKey)
    }
}

struct NotificationsView: View {
    @StateObject private var notificationStore = NotificationStore.shared
    
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
                ForEach(notificationStore.notifications) { notification in
                    NotificationRow(notification: notification)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .listRowSeparator(.hidden)
                        .listRowBackground(
                            notification.isRead
                            ? Theme.Colors.background
                            : Theme.Colors.primaryLight.opacity(0.3)
                        )
                        .onTapGesture {
                            notificationStore.markAsRead(notification)
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
        case .missingIngredients: return "cart.badge.plus"
        }
    }
    
    var iconColor: Color {
        switch notification.type {
        case .newRecipe: return Theme.Colors.primary
        case .follow: return Theme.Colors.tertiary
        case .trending: return Theme.Colors.primary
        case .system: return Theme.Colors.textSecondary
        case .missingIngredients: return Theme.Colors.tertiary
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
