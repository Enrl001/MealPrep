//
//  AuthViewModel.swift
//  MealPrep
//
//  Created by Enerel Tsolmonbayar on 9/5/2026.
//

import Foundation
import SwiftUI
import Combine

class AuthViewModel: ObservableObject {
    private let guestModeKey = "hasContinuedAsGuest"

    @Published var currentUser: User?
    @Published var hasContinuedAsGuest: Bool

    @Published var loginEmail = ""
    @Published var loginPassword = ""

    @Published var signupName = ""
    @Published var signupEmail = ""
    @Published var signupPassword = ""

    @Published var errorMessage = ""

    init() {
        hasContinuedAsGuest = UserDefaults.standard.bool(forKey: guestModeKey)
        currentUser = loadCurrentUser()
    }

    func signUp() {

        let user = User(
            id: UUID().uuidString,
            username: signupEmail,
            password: signupPassword,
            name: signupName
        )

        saveUser(user)
        saveCurrentUser(user)
        setGuestMode(false)

        currentUser = user
    }

    // MARK: - LOGIN

    func login(email: String? = nil, password: String? = nil) {

        let emailToCheck = email ?? loginEmail
        let passwordToCheck = password ?? loginPassword
        let users = loadUsers()

        if let user = users.first(where: {
            $0.username == emailToCheck &&
            $0.password == passwordToCheck
        }) {

            errorMessage = ""
            saveCurrentUser(user)
            setGuestMode(false)
            currentUser = user

        } else {
            errorMessage = "Invalid email or password"
        }
    }

    func logout() {
        UserDefaultManager.shared.clearScheduleAndGroceryData()
        UserDefaults.standard.removeObject(forKey: "currentUser")
        setGuestMode(false)
        currentUser = nil
    }

    func continueAsGuest() {
        setGuestMode(true)
        currentUser = nil
    }

    private func setGuestMode(_ isEnabled: Bool) {
        hasContinuedAsGuest = isEnabled
        UserDefaults.standard.set(isEnabled, forKey: guestModeKey)
    }
}

extension AuthViewModel {

    func saveUser(_ user: User) {

        var users = loadUsers()

        users.append(user)

        if let encoded = try? JSONEncoder().encode(users) {
            UserDefaults.standard.set(encoded, forKey: "users")
        }
    }

    func loadUsers() -> [User] {

        guard let data = UserDefaults.standard.data(forKey: "users"),
              let users = try? JSONDecoder().decode([User].self, from: data)
        else {
            return []
        }

        return users
    }

    func saveCurrentUser(_ user: User) {

        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: "currentUser")
        }
    }

    func loadCurrentUser() -> User? {

        guard let data = UserDefaults.standard.data(forKey: "currentUser"),
              let user = try? JSONDecoder().decode(User.self, from: data)
        else {
            return nil
        }

        return user
    }
}
