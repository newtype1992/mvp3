import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject private var store: AppStore
    @Environment(\.dismiss) private var dismiss
    @State private var customer = CheckoutState.CustomerInfo()
    @State private var promoCode = "AUSTINRUSH"

    var slot: Slot? { store.checkoutState.selectedSlot }
    var business: Business? { slot.flatMap { slot in store.businesses.first { $0.id == slot.businessID } } }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if let slot, let business {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            SheetHeader(title: "Checkout", subtitle: business.name) {
                                dismiss()
                                store.resetCheckout()
                            }

                            summaryCard(slot: slot, business: business)

                            SectionHeader(title: "Your Details")
                            FormField(title: "Full Name", text: $customer.fullName)
                            FormField(title: "Email", text: $customer.email, keyboardType: .emailAddress)
                            FormField(title: "Mobile", text: $customer.phone, keyboardType: .phonePad)

                            SectionHeader(title: "Promo Code")
                            HStack {
                                TextField("Promo Code", text: $promoCode)
                                    .textInputAutocapitalization(.characters)
                                    .padding(12)
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(10)
                                Button("Apply") {}
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                            }

                            SectionHeader(title: "Payment")
                            ApplePayButton()
                                .onTapGesture {
                                    guard !store.checkoutState.isProcessing else { return }
                                    Task {
                                        await store.confirmCheckout(customer: customer)
                                        if store.checkoutState.isConfirmed {
                                            Haptics.success()
                                        }
                                    }
                                }
                                .allowsHitTesting(!store.checkoutState.isProcessing)
                                .padding(.top, 4)

                            if store.checkoutState.isProcessing {
                                ProgressView("Processing...")
                                    .padding()
                            }

                            if store.checkoutState.isConfirmed {
                                ConfirmationView(slot: slot, business: business)
                            }

                            if let error = store.checkoutState.errorMessage {
                                Text(error)
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 24)
                    }
                } else {
                    EmptyState(title: "No slot selected", message: "Head back to the feed to pick a last-minute opening.")
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            customer = store.checkoutState.customerInfo
        }
    }

    private func summaryCard(slot: Slot, business: Business) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text(slot.title)
                        .font(.headline)
                    Text(slot.startDate.formattedTimeRange(endDate: slot.endDate))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                DiscountBadge(text: slot.discountTier.badgeText)
            }
            Divider()
            HStack {
                Text("Subtotal")
                Spacer()
                Text(slot.originalPrice.currencyString())
            }
            HStack {
                Text("Swift Slots Savings")
                Spacer()
                Text("-\(slot.originalPrice - slot.discountedPrice, format: .currency(code: "USD"))")
                    .foregroundColor(.green)
            }
            Divider()
            HStack {
                Text("Total Today")
                    .font(.headline)
                Spacer()
                Text(slot.discountedPrice.currencyString())
                    .font(.headline)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 6)
    }
}

private struct SectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.footnote.weight(.semibold))
            .foregroundColor(.secondary)
            .padding(.top, 12)
    }
}

private struct ApplePayButton: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.black)
            .frame(height: 54)
            .overlay {
                HStack(spacing: 8) {
                    Image(systemName: "applelogo")
                        .font(.title3)
                    Text("Pay")
                        .font(.title3.weight(.semibold))
                }
                .foregroundColor(.white)
            }
            .accessibilityLabel(Text("Apple Pay"))
    }
}
