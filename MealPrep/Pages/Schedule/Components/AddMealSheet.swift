//
//  AddMealSheet.swift
//  
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//
import SwiftUI

struct AddMealSheet: View {
    @ObservedObject var viewModel: ScheduleViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var recipeName = ""
    @State private var selectedMealType: MealType = .breakfast
    @State private var selectedDay = "Mon"
    @State private var selectedTime = "08:30 AM"
    @State private var repeatWeekly = true
    @State private var selectedRepeatDays: Set<String> = ["M0", "W2", "F4"]

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
            sheetHeader
            recipeNameField
            mealTypePicker
            dateAndTimeFields
            repeatSection

            Spacer()

            addMealButton
        }
        .padding(Theme.Spacing.md)
        .background(Theme.Colors.background)
    }

    private var sheetHeader: some View {
        HStack {
            Text("Add to Schedule")
                .font(Theme.Typography.subhead)
                .foregroundColor(Theme.Colors.textPrimary)

            Spacer()

            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(Theme.Colors.textSecondary)
            }
        }
    }

    private var recipeNameField: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Text("Recipe Name")
                .font(Theme.Typography.caption.bold())
                .foregroundColor(Theme.Colors.textSecondary)

            TextField("Enter meal name", text: $recipeName)
                .padding()
                .background(Theme.Colors.surface)
                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
        }
    }

    private var mealTypePicker: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Text("Meal Type")
                .font(Theme.Typography.caption.bold())
                .foregroundColor(Theme.Colors.textSecondary)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 105))], spacing: Theme.Spacing.sm) {
                ForEach(MealType.allCases) { type in
                    Button {
                        selectedMealType = type
                    } label: {
                        Text(type.rawValue)
                            .font(Theme.Typography.caption.bold())
                            .foregroundColor(type.color)
                            .padding(.horizontal, Theme.Spacing.md)
                            .padding(.vertical, Theme.Spacing.sm)
                            .background(selectedMealType == type ? type.lightColor : Theme.Colors.background)
                            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
                            .overlay(
                                RoundedRectangle(cornerRadius: Theme.Radius.md)
                                    .stroke(selectedMealType == type ? type.color : Theme.Colors.divider)
                            )
                    }
                }
            }
        }
    }

    private var dateAndTimeFields: some View {
        HStack(spacing: Theme.Spacing.md) {
            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                Text("Date")
                    .font(Theme.Typography.caption.bold())
                    .foregroundColor(Theme.Colors.textSecondary)

                Picker("Day", selection: $selectedDay) {
                    ForEach(viewModel.fullDays, id: \.self) { day in
                        Text(day)
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Theme.Colors.surface)
                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
            }

            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                Text("Time")
                    .font(Theme.Typography.caption.bold())
                    .foregroundColor(Theme.Colors.textSecondary)

                TextField("08:30 AM", text: $selectedTime)
                    .padding()
                    .background(Theme.Colors.surface)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
            }
        }
    }

    private var repeatSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    Text("Repeat Weekly")
                        .font(Theme.Typography.subhead)
                        .foregroundColor(Theme.Colors.textPrimary)

                    Text("Select days for repeating this meal")
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textSecondary)
                }

                Spacer()

                Toggle("", isOn: $repeatWeekly)
                    .labelsHidden()
                    .tint(Theme.Colors.primary)
            }

            if repeatWeekly {
                MealRepeatPickerView(selectedDays: $selectedRepeatDays)
            }
        }
        .padding()
        .background(Theme.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.lg))
    }

    private var addMealButton: some View {
        Button {
            let finalName = recipeName.isEmpty ? "New Meal" : recipeName

            viewModel.addMeal(
                recipeName: finalName,
                mealType: selectedMealType,
                day: selectedDay,
                time: selectedTime
            )

            dismiss()
        } label: {
            Text("Add to Schedule")
                .font(Theme.Typography.subhead)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Theme.Colors.primary)
                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.md))
        }
    }
}
