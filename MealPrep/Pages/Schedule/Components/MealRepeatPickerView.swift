//
//  MealRepeatPickerView.swift
//  
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//
import SwiftUI

struct MealRepeatPickerView: View {
    @Binding var selectedDays: Set<String>

    let days = ["M", "T", "W", "T", "F", "S", "S"]

    var body: some View {
        HStack {
            ForEach(Array(days.enumerated()), id: \.offset) { index, day in
                let dayKey = "\(day)\(index)"
                let isSelected = selectedDays.contains(dayKey)

                Button {
                    if isSelected {
                        selectedDays.remove(dayKey)
                    } else {
                        selectedDays.insert(dayKey)
                    }
                } label: {
                    Text(day)
                        .font(Theme.Typography.caption.bold())
                        .foregroundColor(isSelected ? .white : Theme.Colors.textSecondary)
                        .frame(width: 32, height: 32)
                        .background(isSelected ? Theme.Colors.primary : Theme.Colors.background)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Theme.Colors.divider)
                        )
                }
            }
        }
    }
}
