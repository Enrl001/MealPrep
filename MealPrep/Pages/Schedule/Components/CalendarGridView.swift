//
//  CalendarGridView.swift
//  
//
//  Created by Enerel Tsolmonbayar on 8/5/2026.
//

import SwiftUI

struct CalendarGridView: View {
    let events: [MealEvent]
    let days: [String]
    let dates: [String]
    let times: [String]

    var body: some View {
        VStack(spacing: 0) {
            dayHeader

            HStack(alignment: .top, spacing: 0) {
                timeColumn
                gridView
            }
        }
        .background(Theme.Colors.background)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.lg))
        .padding(Theme.Spacing.md)
    }

    private var dayHeader: some View {
        HStack {
            Text("GMT+2")
                .font(Theme.Typography.micro)
                .foregroundColor(Theme.Colors.textSecondary)
                .frame(width: 45)

            ForEach(0..<days.count, id: \.self) { index in
                VStack(spacing: Theme.Spacing.xs) {
                    Text(days[index])
                        .font(Theme.Typography.caption)
                        .foregroundColor(Theme.Colors.textSecondary)

                    Text(dates[index])
                        .font(Theme.Typography.subhead)
                        .foregroundColor(index == 2 ? .white : Theme.Colors.textPrimary)
                        .frame(width: 34, height: 34)
                        .background(index == 2 ? Theme.Colors.primary : Color.clear)
                        .clipShape(Circle())
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, Theme.Spacing.md)
    }

    private var timeColumn: some View {
        VStack(spacing: 0) {
            ForEach(times, id: \.self) { time in
                Text(time)
                    .font(Theme.Typography.micro)
                    .foregroundColor(Theme.Colors.textTertiary)
                    .frame(width: 45, height: 72, alignment: .top)
            }
        }
    }

    private var gridView: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: days.count),
            spacing: 0
        ) {
            ForEach(0..<(days.count * times.count), id: \.self) { index in
                let dayIndex = index % days.count
                let rowIndex = index / days.count

                ZStack {
                    Rectangle()
                        .stroke(Theme.Colors.divider, lineWidth: 0.5)
                        .frame(height: 72)

                    ForEach(eventsForCell(dayIndex: dayIndex, rowIndex: rowIndex)) { event in
                        if let recipe = event.recipe {
                            NavigationLink {
                                RecipeDetailView(recipe: recipe)
                            } label: {
                                MealEventBlock(event: event)
                            }
                            .buttonStyle(.plain)
                        } else {
                            MealEventBlock(event: event)
                        }
                    }
                }
            }
        }
    }

    private func eventsForCell(dayIndex: Int, rowIndex: Int) -> [MealEvent] {
        events.filter { event in
            dayToNumber(event.day) == dayIndex &&
            timeToRow(event.time) == rowIndex
        }
    }

    private func dayToNumber(_ day: String) -> Int {
        switch day {
        case "Mon": return 0
        case "Tue": return 1
        case "Wed": return 2
        case "Thu": return 3
        case "Fri": return 4
        case "Sat": return 5
        case "Sun": return 6
        default: return 0
        }
    }

    private func timeToRow(_ time: String) -> Int {
        if time.contains("08") { return 0 }
        if time.contains("10") { return 1 }
        if time.contains("12") { return 2 }
        if time.contains("14") { return 3 }
        if time.contains("16") || time.contains("04") { return 4 }
        if time.contains("18") || time.contains("06") { return 5 }
        return 6
    }
}
