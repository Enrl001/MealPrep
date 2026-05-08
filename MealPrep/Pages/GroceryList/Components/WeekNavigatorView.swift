//
//  WeekNavigatorView.swift
//  
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
import SwiftUI

struct WeekNavigatorView: View {
    let weekLabel: String
    let weekRange: String

    var body: some View {
        HStack {
            Image(systemName: "chevron.left")
                .foregroundColor(Theme.Colors.tertiary)

            Spacer()

            VStack(spacing: Theme.Spacing.xs) {
                Text(weekLabel)
                    .font(Theme.Typography.caption.bold())
                    .foregroundColor(Theme.Colors.textSecondary)

                Text(weekRange)
                    .font(Theme.Typography.subhead)
                    .foregroundColor(Theme.Colors.textPrimary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(Theme.Colors.tertiary)
        }
        .padding()
        .background(Theme.Colors.primaryLight.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.lg))
    }
}
