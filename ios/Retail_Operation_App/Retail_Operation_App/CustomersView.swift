import SwiftUI

struct CustomersView: View {
    @EnvironmentObject private var customerStore: CustomerStore
    @EnvironmentObject private var salesStore: SalesStore
    @AppStorage("checkoutCustomerId") private var checkoutCustomerId = ""

    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredCustomers) { customer in
                    NavigationLink {
                        CustomerDetailView(customerId: customer.id)
                    } label: {
                        CustomerRow(
                            customer: customer,
                            lastReceipt: salesStore.receipts(for: customer.id).first,
                            isSelectedForCheckout: checkoutCustomerId == customer.id.uuidString
                        )
                    }
                }
            }
            .navigationTitle("Customers")
            .searchable(text: $searchText, prompt: "Search by name, email, phone")
        }
    }

    private var filteredCustomers: [Customer] {
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !q.isEmpty else { return customerStore.customers }
        return customerStore.customers.filter { customer in
            customer.displayName.lowercased().contains(q) ||
            customer.email?.lowercased().contains(q) == true ||
            customer.phone?.lowercased().contains(q) == true
        }
    }
}

private struct CustomerRow: View {
    let customer: Customer
    let lastReceipt: SaleReceipt?
    let isSelectedForCheckout: Bool

    var body: some View {
        HStack(spacing: 12) {
            Text(customer.initials)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(width: 34, height: 34)
                .background(Color(red: 0.55, green: 0.62, blue: 0.70))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 3) {
                Text(customer.displayName)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                if let lastReceipt {
                    Text("Last purchase: \(lastReceipt.createdAt, format: .dateTime.month().day().year()) • \(lastReceipt.formattedTotal)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    Text("No purchases yet")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            if isSelectedForCheckout {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.tint)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    CustomersView()
        .environmentObject(CustomerStore())
        .environmentObject(SalesStore())
}

