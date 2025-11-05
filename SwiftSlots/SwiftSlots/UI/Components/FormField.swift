import SwiftUI

struct FormField: View {
    let title: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.footnote.weight(.semibold))
                .foregroundColor(.secondary)
            TextField(title, text: $text)
                .textInputAutocapitalization(.words)
                .keyboardType(keyboardType)
                .padding(12)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
        }
    }
}
