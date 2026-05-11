//
//  PotluckCard.swift
//  
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//

import SwiftUI

struct PotluckCard: View {
    let potluck: PotluckEvent
    var onJoin: (() -> Void)? = nil

    private var dateText: String {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("EEE, MMM d • h:mm a")
        return formatter.string(from: potluck.date)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                    Text(potluck.category.uppercased())
                        .font(Theme.Typography.micro)
                        .fontWeight(.semibold)
                        .foregroundStyle(Theme.Colors.tertiary)
                        .padding(.horizontal, Theme.Spacing.sm)
                        .padding(.vertical, Theme.Spacing.xs)
                        .background(Theme.Colors.tertiaryLight)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm))

                    Text(potluck.title)
                        .font(Theme.Typography.heading)
                        .foregroundStyle(Theme.Colors.textPrimary)
                        .fixedSize(horizontal: false, vertical: true)
                }

            }

            Label(dateText, systemImage: "clock")
                .font(Theme.Typography.body)
                .foregroundStyle(Theme.Colors.textSecondary)

            if !potluck.location.isEmpty {
                Label(potluck.location, systemImage: "mappin.and.ellipse")
                    .font(Theme.Typography.body)
                    .foregroundStyle(Theme.Colors.textSecondary)
            }

            Divider()

            HStack(spacing: Theme.Spacing.sm) {
                Circle()
                    .fill(Theme.Colors.primaryLight)
                    .frame(width: 34, height: 34)
                    .overlay {
                        Image(systemName: "person.fill")
                            .font(.system(size: Theme.IconSize.sm, weight: .semibold))
                            .foregroundStyle(Theme.Colors.primary)
                    }

                Text(potluck.hostName)
                    .font(Theme.Typography.caption)
                    .foregroundStyle(Theme.Colors.textSecondary)

                Spacer()

                Button("View") {
                    onJoin?()
                }
                .font(Theme.Typography.subhead)
                .foregroundStyle(Theme.Colors.primary)
            }
        }
        .padding(Theme.Spacing.md)
        .background(Theme.Colors.background)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.md)
                .stroke(Theme.Colors.divider)
        )
    }
}
