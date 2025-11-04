import SwiftUI

struct SheetHeader: View {
    let title: String
    var subtitle: String? = nil
    var dismiss: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 4) {
            Capsule()
                .fill(Color(.systemGray4))
                .frame(width: 40, height: 5)
                .padding(.top, 8)
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.title3.bold())
                    if let subtitle {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
                if let dismiss {
                    Button(role: .cancel, action: dismiss) {
                        Image(systemName: "xmark")
                            .font(.headline)
                    }
                }
            }
            .padding(.top, 8)
        }
        .padding(.horizontal)
        .padding(.bottom, 12)
    }
}
