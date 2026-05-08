import SwiftUI

struct GroceryChecklistSection: View {
    let section: (category: GroceryCategory, items: [GroceryItem])
    let onToggle: (GroceryItem) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.md) {
            sectionHeader

            VStack(spacing: 0) {
                ForEach(section.items) { item in
                    GroceryItemRow(item: item) {
                        onToggle(item)
                    }

                    if item.id != section.items.last?.id {
                        Divider()
                            .background(Theme.Colors.divider)
                    }
                }
            }
            .background(Theme.Colors.background)
            .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.lg))
            .overlay(
                RoundedRectangle(cornerRadius: Theme.Radius.lg)
                    .stroke(Theme.Colors.divider)
            )
        }
    }

    private var sectionHeader: some View {
        HStack {
            Rectangle()
                .fill(section.category.accentColor)
                .frame(width: 4, height: 28)
                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.sm))

            Text(section.category.rawValue)
                .font(Theme.Typography.subhead)
                .foregroundColor(Theme.Colors.textPrimary)

            Spacer()

            Text("\(section.items.count) Items")
                .font(Theme.Typography.caption.bold())
                .foregroundColor(section.category.accentColor)
                .padding(.horizontal, Theme.Spacing.sm)
                .padding(.vertical, Theme.Spacing.xs)
                .background(section.category.accentColor.opacity(0.15))
                .clipShape(Capsule())
        }
    }
}
