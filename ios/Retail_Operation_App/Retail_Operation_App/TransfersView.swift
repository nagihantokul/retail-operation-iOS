import SwiftUI

// MARK: - Transfers View (Incoming Transfer Requests)

struct TransfersView: View {
    let storeId: Int

    @AppStorage("apiBaseURL") private var apiBaseURL = "http://localhost:8080"

    @State private var transfers: [TransferRequestResponse] = []
    @State private var isLoading = true
    @State private var selectedTransfer: TransferRequestResponse?

    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading transfers...")
            } else if transfers.isEmpty {
                emptyState
            } else {
                transfersList
            }
        }
        .navigationTitle("Transfers")
        .task {
            await loadTransfers()
        }
        .refreshable {
            await loadTransfers()
        }
        .sheet(item: $selectedTransfer) { transfer in
            TransferDetailSheet(transfer: transfer) {
                await loadTransfers()
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "arrow.left.arrow.right")
                .font(.system(size: 50))
                .foregroundStyle(.tertiary)

            Text("No Pending Transfers")
                .font(.headline)

            Text("Incoming transfer requests\nwill appear here")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }

    private var transfersList: some View {
        List(transfers) { transfer in
            Button {
                selectedTransfer = transfer
            } label: {
                TransferRow(transfer: transfer)
            }
            .buttonStyle(.plain)
        }
        .listStyle(.plain)
    }

    @MainActor
    private func loadTransfers() async {
        do {
            let client = try APIClient(baseURLString: apiBaseURL)
            transfers = try await client.getIncomingTransfers(storeId: storeId)
        } catch {
            // Fallback to mock data
            transfers = MockData.transfers(for: storeId)
        }
        isLoading = false
    }
}

// MARK: - Transfer Row

struct TransferRow: View {
    let transfer: TransferRequestResponse

    var body: some View {
        HStack(spacing: 12) {
            statusIcon
                .frame(width: 44, height: 44)
                .background(statusColor.opacity(0.15))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(transfer.productName)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Text("From: \(transfer.fromStoreName)")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text("\(transfer.quantity) units")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }

            Spacer()

            Text(statusText)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(statusColor.opacity(0.15))
                .foregroundStyle(statusColor)
                .clipShape(Capsule())

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }

    private var statusIcon: some View {
        Image(systemName: iconName)
            .font(.title3)
            .foregroundStyle(statusColor)
    }

    private var iconName: String {
        switch transfer.status {
        case "PENDING": return "clock.fill"
        case "APPROVED": return "checkmark.circle.fill"
        case "SHIPPED": return "shippingbox.fill"
        case "RECEIVED": return "checkmark.seal.fill"
        default: return "arrow.left.arrow.right"
        }
    }

    private var statusText: String {
        switch transfer.status {
        case "PENDING": return "Pending"
        case "APPROVED": return "Approved"
        case "SHIPPED": return "In Transit"
        case "RECEIVED": return "Received"
        default: return transfer.status
        }
    }

    private var statusColor: Color {
        switch transfer.status {
        case "PENDING": return Color(red: 0.88, green: 0.82, blue: 0.72)
        case "APPROVED": return Color(red: 0.55, green: 0.75, blue: 0.75)
        case "SHIPPED": return Color(red: 0.75, green: 0.72, blue: 0.82)
        case "RECEIVED": return Color(red: 0.65, green: 0.78, blue: 0.68)
        default: return .gray
        }
    }
}

// MARK: - Transfer Detail Sheet

struct TransferDetailSheet: View {
    let transfer: TransferRequestResponse
    let onUpdate: () async -> Void

    @Environment(\.dismiss) private var dismiss
    @AppStorage("apiBaseURL") private var apiBaseURL = "http://localhost:8080"
    @State private var isUpdating = false

    var body: some View {
        NavigationStack {
            List {
                Section("Product") {
                    HStack(spacing: 12) {
                        AsyncImage(url: URL(string: transfer.productImageUrl ?? "")) { phase in
                            if case .success(let image) = phase {
                                image.resizable().aspectRatio(contentMode: .fill)
                            } else {
                                Image(systemName: "tshirt")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .frame(width: 50, height: 50)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                        VStack(alignment: .leading) {
                            Text(transfer.productName)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Text(transfer.productSku)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section("Transfer Details") {
                    LabeledContent("From Store", value: transfer.fromStoreName)
                    LabeledContent("To Store", value: transfer.toStoreName)
                    LabeledContent("Quantity", value: "\(transfer.quantity) units")
                    LabeledContent("Status", value: transfer.status)

                    if let notes = transfer.notes {
                        LabeledContent("Notes", value: notes)
                    }
                }

                if transfer.status == "SHIPPED" {
                    Section {
                        Button {
                            Task { await markReceived() }
                        } label: {
                            HStack {
                                if isUpdating {
                                    ProgressView()
                                } else {
                                    Image(systemName: "checkmark.circle.fill")
                                    Text("Mark as Received")
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(isUpdating)
                    }
                }
            }
            .navigationTitle("Transfer Request")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    @MainActor
    private func markReceived() async {
        isUpdating = true
        // API call would go here
        try? await Task.sleep(nanoseconds: 500_000_000)
        await onUpdate()
        dismiss()
    }
}

// MARK: - Mock Data Extension

extension MockData {
    static func transfers(for storeId: Int) -> [TransferRequestResponse] {
        [
            TransferRequestResponse(
                id: 1,
                fromStoreId: 2,
                fromStoreName: "Market Street",
                toStoreId: Int64(storeId),
                toStoreName: "Union Square",
                productId: 1,
                productName: "Wool Blend Blazer - Black",
                productSku: "BLZ-WOL-BLK",
                productImageUrl: products[0].imageUrl,
                quantity: 5,
                status: "SHIPPED",
                notes: "Urgent request for weekend sale",
                createdAt: "2024-01-26T10:00:00Z"
            ),
            TransferRequestResponse(
                id: 2,
                fromStoreId: 3,
                fromStoreName: "Mission District",
                toStoreId: Int64(storeId),
                toStoreName: "Union Square",
                productId: 5,
                productName: "Leather Jacket - Brown",
                productSku: "JKT-LTH-BRN",
                productImageUrl: products[4].imageUrl,
                quantity: 3,
                status: "PENDING",
                notes: nil,
                createdAt: "2024-01-26T09:00:00Z"
            ),
        ]
    }
}

#Preview {
    NavigationStack {
        TransfersView(storeId: 1)
    }
}
