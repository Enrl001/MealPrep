//
//  SearchBarView.swift
//  
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//
import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack(spacing: Theme.Spacing.sm) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Theme.Colors.textTertiary)
            
            TextField("Search recipes, ingredients...", text: $searchText)
                .font(Theme.Typography.body)
                .foregroundStyle(Theme.Colors.textPrimary)
        }
        .padding(Theme.Spacing.sm)
        .background(Theme.Colors.primaryLight)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.pill))
    }
}

#Preview {
    SearchBarView(searchText: .constant(""))
        .padding()
}
