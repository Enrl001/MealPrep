//
//  CuisineFilterChips.swift
//  
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//

import SwiftUI

struct CuisineFilterChips: View {
    let cuisines: [String]
    @Binding var selected: String
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Theme.Spacing.sm) {
                ForEach(cuisines, id: \.self) { cuisine in
                    Button {
                        selected = cuisine
                    } label: {
                        Text(cuisine)
                            .font(Theme.Typography.body)
                            .foregroundStyle(
                                selected == cuisine
                                ? Theme.Colors.background
                                : Theme.Colors.textSecondary
                            )
                            .padding(.horizontal, Theme.Spacing.md)
                            .padding(.vertical, Theme.Spacing.xs)
                            .background(
                                selected == cuisine
                                ? Theme.Colors.primary
                                : Theme.Colors.background
                            )
                            .clipShape(Capsule())
                            .overlay {
                                if selected != cuisine {
                                    Capsule()
                                        .stroke(Theme.Colors.divider, lineWidth: 1)
                                }
                            }
                    }
                }
            }
            .padding(.horizontal, Theme.Spacing.md)
        }
    }
}

#Preview {
    CuisineFilterChips(
        cuisines: ["Italian", "Mexican", "Vegan", "Japanese", "Chinese"],
        selected: .constant("Italian")
    )
}
