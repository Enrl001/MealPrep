//
//  PotluckViewModel.swift
//  
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//

import Combine
import Foundation

struct PotluckEvent: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var category: String
    var location: String
    var hostName: String
    var date: Date

    init(
        id: UUID = UUID(),
        title: String,
        category: String,
        location: String,
        hostName: String,
        date: Date
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.location = location
        self.hostName = hostName
        self.date = date
    }
}

final class PotluckViewModel: ObservableObject {
    @Published private(set) var userPotlucks: [PotluckEvent] = []

    private var currentUserID: String?

    var samplePotlucks: [PotluckEvent] {
        [
            PotluckEvent(
                title: "High-Protein Meal Prep Meetup",
                category: "Healthy Social",
                location: "Community Kitchen",
                hostName: "Mark J.",
                date: Calendar.current.date(byAdding: .day, value: 5, to: Date()) ?? Date()
            ),
            PotluckEvent(
                title: "Keto-Friendly Backyard BBQ",
                category: "Neighborhood",
                location: "Lincoln Park Pavilion",
                hostName: "Sarah K.",
                date: Calendar.current.date(byAdding: .day, value: 6, to: Date()) ?? Date()
            )
        ]
    }

    var potlucks: [PotluckEvent] {
        (userPotlucks + samplePotlucks).sorted { $0.date < $1.date }
    }

    func load(for userID: String) {
        currentUserID = userID

        guard let data = UserDefaults.standard.data(forKey: storageKey(for: userID)),
              let decoded = try? JSONDecoder().decode([PotluckEvent].self, from: data)
        else {
            userPotlucks = []
            return
        }

        userPotlucks = decoded.sorted { $0.date < $1.date }
    }

    func addPotluck(_ potluck: PotluckEvent) {
        guard let currentUserID else { return }

        userPotlucks.append(potluck)
        userPotlucks.sort { $0.date < $1.date }
        save(for: currentUserID)
    }

    private func save(for userID: String) {
        guard let encoded = try? JSONEncoder().encode(userPotlucks) else { return }
        UserDefaults.standard.set(encoded, forKey: storageKey(for: userID))
    }

    private func storageKey(for userID: String) -> String {
        "potlucks_\(userID)"
    }
}
