import SwiftUI

struct AppHeaderView: View {
    @EnvironmentObject private var authVM: AuthViewModel
    @StateObject private var notificationStore = NotificationStore.shared
    @State private var authDestination: AuthDestination?
    @State private var showNotifications = false

    private var hasUnreadNotifications: Bool {
        notificationStore.notifications.contains { !$0.isRead }
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

    var body: some View {
        ZStack {
            Text("MealPrep")
                .font(Theme.Typography.heading)
                .foregroundStyle(Theme.Colors.primary)

            HStack {
                Button {
                    showNotifications = true
                } label: {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "bell")
                            .font(.system(size: 18))
                            .foregroundStyle(Theme.Colors.textPrimary)
                            .frame(width: 38, height: 38)

                        if hasUnreadNotifications {
                            Circle()
                                .fill(Theme.Colors.primary)
                                .frame(width: 8, height: 8)
                                .offset(x: -8, y: 8)
                        }
                    }
                }
                .accessibilityLabel("Notifications")

                Spacer()

                settingsMenu
            }
        }
        .padding(.horizontal, Theme.Spacing.md)
        .padding(.vertical, Theme.Spacing.sm)
        .background(Theme.Colors.background)
        .navigationDestination(isPresented: $showNotifications) {
            NotificationsView()
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
        .onChange(of: authVM.currentUser?.id) { _, userID in
            if userID != nil {
                authDestination = nil
            }
        }
    }

    private var settingsMenu: some View {
        Menu {
            if authVM.currentUser == nil {
                Button {
                    authDestination = .login
                } label: {
                    Label("Login", systemImage: "person.crop.circle.badge.plus")
                }
            } else {
                Button(role: .destructive) {
                    authVM.logout()
                } label: {
                    Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                }
            }
        } label: {
            Image(systemName: "gearshape")
                .font(.system(size: 18))
                .foregroundStyle(Theme.Colors.textPrimary)
                .frame(width: 38, height: 38)
        }
        .accessibilityLabel("Settings")
    }
}
