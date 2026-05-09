//
//  Blogger.swift
//  MealPrep
//
//  Created by Hline Nadi Khant on 8/5/2026.
//

import Foundation

struct Blogger: Identifiable {
    let id: UUID
    let name: String
    let imageURL: String
    let bio: String
    let followers: Int
    let specialties: [String]
    var isFollowing: Bool = false
}
