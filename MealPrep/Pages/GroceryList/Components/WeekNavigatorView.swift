//
//  WeekNavigatorView.swift
//  
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
import SwiftUI

struct WeekNavigatorView: View {
    let weekLabel: String
    let weekRange: String
    var onPreviousWeek: () -> Void = {}
    var onNextWeek: () -> Void = {}

    var body: some View {
        HStack {
            Button(action: onPreviousWeek) {
                Image(systemName: "chevron.left")
                    .foregroundColor(Theme.Colors.tertiary)
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)

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

            Button(action: onNextWeek) {
                Image(systemName: "chevron.right")
                    .foregroundColor(Theme.Colors.tertiary)
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(Theme.Colors.primaryLight.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.lg))
    }
}
