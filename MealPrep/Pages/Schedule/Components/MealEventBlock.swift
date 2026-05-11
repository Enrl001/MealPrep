//
//  MealEventBlock.swift
//  
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//
import SwiftUI

struct MealEventBlock: View {
    let event: MealEvent

    var body: some View {
        HStack(spacing: Theme.Spacing.xs) {
            Rectangle()
                .fill(event.mealType.color)
                .frame(width: 4)

            VStack(alignment: .leading, spacing: 2) {
                Text(event.recipeName)
                    .font(Theme.Typography.micro.bold())
                    .foregroundColor(event.mealType.color)
                    .lineLimit(1)

                Text(event.time)
                    .font(Theme.Typography.micro)
                    .foregroundColor(event.mealType.color)
            }

            Spacer()
        }
        .padding(Theme.Spacing.xs)
        .frame(height: 58)
        .background(event.mealType.lightColor)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm))
        .padding(4)
    }
}
