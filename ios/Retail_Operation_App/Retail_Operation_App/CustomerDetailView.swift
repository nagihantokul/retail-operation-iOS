import SwiftUI

struct CustomerDetailView: View {
    let customerId: UUID

    @EnvironmentObject private var customerStore: CustomerStore
    @EnvironmentObject private var salesStore: SalesStore
    @AppStorage("checkoutCustomerId") private var checkoutCustomerId = ""

    @State private var notesDraft = ""
    @State private var didLoadNotes = false

    var body: some View {
        Group {
            if let customer {
                Form {
                    Section("Profile") {
                        LabeledContent("Name", value: customer.displayName)
                        if let email = customer.email {
                            LabeledContent("Email", value: email)
                        }
                        if let phone = customer.phone {
                            LabeledContent("Phone", value: phone)
                        }
                    }

                    if !customer.preferredCategories.isEmpty {
                        Section("Preferences") {
                            FlowLayout(spacing: 8) {
                                ForEach(customer.preferredCategories, id: \.self) { value in
                                    Text(value)
                                        .font(.caption)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(Color(.systemGray6))
                                        .clipShape(Capsule())
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }

                    Section("Notes") {
                        TextEditor(text: $notesDraft)
                            .frame(minHeight: 120)
                    }

                    Section {
                        Button {
                            checkoutCustomerId = customer.id.uuidString
                        } label: {
                            Label("Use for Checkout", systemImage: "creditcard")
                        }

                        if checkoutCustomerId == customer.id.uuidString {
                            Text("Selected for checkout.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }

                    purchaseHistorySection
                }
            } else {
                ContentUnavailableView("Customer not found", systemImage: "person.crop.circle.badge.questionmark")
            }
        }
        .navigationTitle(customer?.displayName ?? "Customer")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                if canSaveNotes {
                    Button("Save") { saveNotes() }
                }
            }
        }
        .task {
            loadNotesIfNeeded()
        }
    }

    private var customer: Customer? {
        customerStore.customer(id: customerId)
    }

    private var canSaveNotes: Bool {
        guard let customer else { return false }
        return didLoadNotes && notesDraft != customer.notes
    }

    private func loadNotesIfNeeded() {
        guard let customer, !didLoadNotes else { return }
        notesDraft = customer.notes
        didLoadNotes = true
    }

    private func saveNotes() {
        customerStore.updateNotes(customerId: customerId, notes: notesDraft)
    }

    @ViewBuilder
    private var purchaseHistorySection: some View {
        let receipts = salesStore.receipts(for: customerId)

        Section("Purchase History") {
            if receipts.isEmpty {
                Text("No purchases yet.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(receipts) { receipt in
                    NavigationLink {
                        ReceiptDetailView(receipt: receipt)
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(receipt.createdAt, format: .dateTime.month().day().year().hour().minute())
                                    .font(.subheadline)
                                Text("\(receipt.items.count) items • \(receipt.paymentMethod.rawValue)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(receipt.formattedTotal)
                                .fontWeight(.semibold)
                        }
                    }
                }
            }
        }
    }
}

private struct FlowLayout<Content: View>: View {
    let spacing: CGFloat
    @ViewBuilder var content: () -> Content

    init(spacing: CGFloat = 8, @ViewBuilder content: @escaping () -> Content) {
        self.spacing = spacing
        self.content = content
    }

    var body: some View {
        GeometryReader { geometry in
            generateContent(in: geometry)
        }
        .frame(minHeight: 0)
    }

    private func generateContent(in geometry: GeometryProxy) -> some View {
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0

        return ZStack(alignment: .topLeading) {
            content()
                .alignmentGuide(.leading) { dimension in
                    if currentX + dimension.width > geometry.size.width {
                        currentX = 0
                        currentY -= dimension.height + spacing
                    }
                    let result = currentX
                    currentX += dimension.width + spacing
                    return result
                }
                .alignmentGuide(.top) { _ in
                    let result = currentY
                    return result
                }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    NavigationStack {
        CustomerDetailView(customerId: MockData.customers[0].id)
    }
    .environmentObject(CustomerStore())
    .environmentObject(SalesStore())
}

