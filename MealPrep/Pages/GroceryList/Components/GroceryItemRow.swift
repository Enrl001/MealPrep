import SwiftUI

struct GroceryItemRow: View {
    let item: GroceryItem
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: Theme.Spacing.md) {
                Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: Theme.IconSize.md))
                    .foregroundStyle(item.isChecked ? Theme.Colors.success : Theme.Colors.textTertiary)

                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    Text(item.name)
                        .font(Theme.Typography.body)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .strikethrough(item.isChecked, color: Theme.Colors.textSecondary)

                    if !item.quantity.isEmpty {
                        Text(item.quantity)
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.Colors.textSecondary)
                    }
                }

                Spacer()
            }
            .padding(.horizontal, Theme.Spacing.md)
            .padding(.vertical, Theme.Spacing.sm + Theme.Spacing.xs)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
