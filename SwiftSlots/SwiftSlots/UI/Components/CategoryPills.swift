import SwiftUI

struct CategoryPills: View {
    let categories: [Category]
    @Binding var selected: Set<UUID>

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories) { category in
                    let isSelected = selected.contains(category.id)
                    Button {
                        if isSelected {
                            selected.remove(category.id)
                        } else {
                            selected.insert(category.id)
                        }
                        Haptics.impact(.light)
                    } label: {
                        Label(category.name, systemImage: category.symbolName)
                            .labelStyle(.titleAndIcon)
                            .font(.footnote.weight(.semibold))
                            .padding(.vertical, 10)
                            .padding(.horizontal, 14)
                            .background(isSelected ? Theme.gradient(for: category) : Color(.systemGray6))
                            .foregroundColor(isSelected ? .white : .primary)
                            .clipShape(Capsule())
                            .accessibilityAddTraits(isSelected ? .isSelected : .isButton)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }
}
