import SwiftUI

struct GroceryItemRow: View {
    let item: GroceryItem
    let onToggle: () -> Void

    var body: some View {
        Button {
            onToggle()
        } label: {
            HStack(spacing: Theme.Spacing.md) {
                Image(systemName: item.isBought ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(item.isBought ? Theme.Colors.success : Theme.Colors.textTertiary)

                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    Text(item.name)
                        .font(Theme.Typography.body.weight(.semibold))
                        .foregroundColor(item.isBought ? Theme.Colors.textTertiary : Theme.Colors.textPrimary)
                        .strikethrough(item.isBought)

                    if !item.note.isEmpty {
                        Text(item.note)
                            .font(Theme.Typography.caption)
                            .foregroundColor(Theme.Colors.textSecondary)
                    }
                }

                Spacer()

                Text(item.quantity)
                    .font(Theme.Typography.body.weight(.semibold))
                    .foregroundColor(item.isBought ? Theme.Colors.textTertiary : Theme.Colors.tertiary)
            }
            .padding()
            .opacity(item.isBought ? 0.6 : 1.0)
        }
        .buttonStyle(.plain)
    }
}
