import SwiftUI

struct CheckoutSheetView: View {
    let apiBaseURL: String
    let storeId: Int
    let storeName: String
    let customer: Customer?
    let cartItems: [CheckoutCartItem]
    let taxRate: Double
    let onCompleted: (SaleReceipt) -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var paymentMethod: PaymentMethod = .card
    @State private var isProcessing = false
    @State private var errorMessage: String?
    @State private var receipt: SaleReceipt?

    var body: some View {
        NavigationStack {
            if let receipt {
                successView(receipt: receipt)
            } else {
                formView
            }
        }
    }

    private var formView: some View {
        Form {
            Section("Summary") {
                LabeledContent("Items", value: "\(cartItems.reduce(0) { $0 + $1.quantity })")
                LabeledContent("Subtotal", value: Money.formatUSD(cents: subtotalCents))
                LabeledContent("Tax", value: Money.formatUSD(cents: taxCents))
                LabeledContent("Total") {
                    Text(Money.formatUSD(cents: totalCents))
                        .fontWeight(.semibold)
                }
            }

            if let customer {
                Section("Customer") {
                    LabeledContent("Name", value: customer.displayName)
                    if let email = customer.email {
                        LabeledContent("Email", value: email)
                    }
                    if let phone = customer.phone {
                        LabeledContent("Phone", value: phone)
                    }
                }
            }

            Section("Payment") {
                Picker("Method", selection: $paymentMethod) {
                    ForEach(PaymentMethod.allCases) { method in
                        Label(method.rawValue, systemImage: method.systemImage)
                            .tag(method)
                    }
                }
            }

            if let errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundStyle(Color(red: 0.90, green: 0.65, blue: 0.60))
                        .font(.caption)
                }
            }

            Section {
                Button {
                    Task { await processPaymentAndCommitInventory() }
                } label: {
                    HStack(spacing: 10) {
                        if isProcessing {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Image(systemName: "checkmark.circle.fill")
                        }
                        Text(isProcessing ? "Processing…" : "Complete Sale")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(red: 0.55, green: 0.75, blue: 0.68))
                .disabled(isProcessing)
            }
        }
        .navigationTitle("Payment")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
                    .disabled(isProcessing)
            }
        }
    }

    private func successView(receipt: SaleReceipt) -> some View {
        VStack(spacing: 18) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 72))
                .foregroundStyle(Color(red: 0.65, green: 0.78, blue: 0.68))

            Text("Sale Complete")
                .font(.title2)
                .fontWeight(.semibold)

            Text(receipt.formattedTotal)
                .font(.system(size: 42, weight: .bold, design: .rounded))

            Text("\(receipt.items.count) item(s) • \(receipt.paymentMethod.rawValue)")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Spacer()

            Button("Done") { dismiss() }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color(red: 0.55, green: 0.75, blue: 0.68))
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .padding(.horizontal)
        }
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .navigationBar)
    }

    private var subtotalCents: Int {
        cartItems.reduce(0) { $0 + $1.lineTotalCents }
    }

    private var taxCents: Int {
        Int((Double(subtotalCents) * taxRate).rounded())
    }

    private var totalCents: Int {
        subtotalCents + taxCents
    }

    @MainActor
    private func processPaymentAndCommitInventory() async {
        isProcessing = true
        errorMessage = nil

        do {
            // Mock payment processing delay
            try? await Task.sleep(nanoseconds: 800_000_000)

            let client = try APIClient(baseURLString: apiBaseURL)
            let baseReason = buildReason()

            for item in cartItems {
                try await client.adjustInventory(
                    storeId: storeId,
                    productId: Int(item.product.id),
                    delta: -item.quantity,
                    reason: baseReason
                )
            }

            let receipt = SaleReceipt(
                id: UUID(),
                createdAt: Date(),
                storeId: storeId,
                storeName: storeName,
                customerId: customer?.id,
                customerName: customer?.displayName,
                paymentMethod: paymentMethod,
                subtotalCents: subtotalCents,
                taxCents: taxCents,
                totalCents: totalCents,
                items: cartItems.map { item in
                    SaleLineItem(
                        productId: item.product.id,
                        sku: item.product.sku,
                        name: item.product.name,
                        imageUrl: item.product.imageUrl,
                        quantity: item.quantity,
                        unitPriceCents: item.unitPriceCents
                    )
                }
            )

            self.receipt = receipt
            onCompleted(receipt)
        } catch {
            errorMessage = error.localizedDescription
        }

        isProcessing = false
    }

    private func buildReason() -> String {
        var parts: [String] = ["POS sale", paymentMethod.rawValue]
        if let name = customer?.displayName, !name.isEmpty {
            parts.append(name)
        }
        let result = parts.joined(separator: " • ")
        return String(result.prefix(255))
    }
}

#Preview {
    CheckoutSheetView(
        apiBaseURL: "http://localhost:8080",
        storeId: 1,
        storeName: "Union Square",
        customer: MockData.customers.first,
        cartItems: [
            CheckoutCartItem(product: MockData.products[0], quantity: 2),
            CheckoutCartItem(product: MockData.products[2], quantity: 1),
        ],
        taxRate: 0.0825
    ) { _ in }
}

