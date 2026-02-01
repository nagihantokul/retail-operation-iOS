import SwiftUI

struct CustomerPickerView: View {
    let customers: [Customer]
    let selectedCustomerId: UUID?
    let onSelect: (Customer?) -> Void

    @State private var searchText = ""

    var body: some View {
        List {
            Section {
                Button {
                    onSelect(nil)
                } label: {
                    HStack {
                        Image(systemName: "person.crop.circle.badge.xmark")
                            .foregroundStyle(.secondary)
                        Text("No Customer")
                        Spacer()
                        if selectedCustomerId == nil {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.tint)
                        }
                    }
                }
            }

            Section("Customers") {
                ForEach(filteredCustomers) { customer in
                    Button {
                        onSelect(customer)
                    } label: {
                        HStack(spacing: 12) {
                            Text(customer.initials)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .frame(width: 32, height: 32)
                                .background(Color.indigo)
                                .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 2) {
                                Text(customer.displayName)
                                Text([customer.email, customer.phone].compactMap { $0 }.joined(separator: " • "))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                            }

                            Spacer()

                            if selectedCustomerId == customer.id {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.tint)
                            }
                        }
                    }
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search customers")
    }

    private var filteredCustomers: [Customer] {
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !q.isEmpty else { return customers }
        return customers.filter { customer in
            customer.displayName.lowercased().contains(q) ||
            customer.email?.lowercased().contains(q) == true ||
            customer.phone?.lowercased().contains(q) == true
        }
    }
}

#Preview {
    NavigationStack {
        CustomerPickerView(customers: MockData.customers, selectedCustomerId: MockData.customers.first?.id) { _ in }
            .navigationTitle("Select Customer")
    }
}

