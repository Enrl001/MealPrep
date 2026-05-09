//
//  User.swift
//  MealPrep
//
//  Created by Enerel Tsolmonbayar on 9/5/2026.
//

import Foundation

struct User: Codable {
    let id: String
    let username: String
    let password: String
    let name: String?

    var displayName: String {
        guard let name, !name.isEmpty else {
            return username
        }

        return name
    }
}

func saveCurrentUser(_ user: User) {
    do {
        let data = try JSONEncoder().encode(user)
        UserDefaults.standard.set(data, forKey: "currentUser")
    } catch {
        print("Failed to save user:", error)
    }
}

func loadCurrentUser() -> User? {
    guard let data = UserDefaults.standard.data(forKey: "currentUser") else {
        return nil
    }

    do {
        return try JSONDecoder().decode(User.self, from: data)
    } catch {
        print("Failed to load user:", error)
        return nil
    }
}
