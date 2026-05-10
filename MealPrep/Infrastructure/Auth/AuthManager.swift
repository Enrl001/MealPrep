//
//  AuthManager.swift
//  
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//

import SwiftUI

@Observable
class AuthManager {
    static let shared = AuthManager()
    
    var isLoggedIn: Bool = false
    
    private init() {}
}
