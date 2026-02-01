import SwiftUI

struct ReceiptDetailView: View {
    let receipt: SaleReceipt

    var body: some View {
        List {
            Section("Receipt Details") {
                LabeledContent("Date", value: receipt.createdAt, format: .dateTime.month().day().year().hour().minute())
                LabeledContent("Payment", value: receipt.paymentMethod.rawValue)
                LabeledContent("Store", value: receipt.storeName)
            }

            Section("Items") {
                ForEach(receipt.items) { item in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.name)
                                .font(.subheadline)
                            Text(item.sku)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        VStack(alignment: .trailing, spacing: 2) {
                            Text("×\(item.quantity)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text(Money.formatUSD(cents: item.lineTotalCents))
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                    }
                }
            }

            Section("Totals") {
                HStack {
                    Text("Subtotal")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(Money.formatUSD(cents: receipt.subtotalCents))
                }

                HStack {
                    Text("Tax")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(Money.formatUSD(cents: receipt.taxCents))
                }

                HStack {
                    Text("Total")
                        .fontWeight(.semibold)
                    Spacer()
                    Text(receipt.formattedTotal)
                        .fontWeight(.bold)
                }
            }
        }
        .navigationTitle("Receipt")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ReceiptDetailView(receipt: SaleReceipt(
            id: UUID(),
            createdAt: Date(),
            storeId: 1,
            storeName: "Union Square",
            customerId: nil,
            customerName: nil,
            paymentMethod: .card,
            subtotalCents: 3980,
            taxCents: 348,
            totalCents: 4328,
            items: [
                SaleLineItem(
                    productId: 1,
                    sku: "TSH-CTN-WHT",
                    name: "Cotton T-Shirt",
                    imageUrl: nil,
                    quantity: 2,
                    unitPriceCents: 1990
                )
            ]
        ))
    }
}
