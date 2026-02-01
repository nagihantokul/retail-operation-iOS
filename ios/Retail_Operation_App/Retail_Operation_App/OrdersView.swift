import SwiftUI

// MARK: - Orders View (BOPIS)

struct OrdersView: View {
    let apiBaseURL: String
    let storeId: Int

    @State private var orders: [BopisOrderResponse] = []
    @State private var isLoading = true
    @State private var selectedOrder: BopisOrderResponse?

    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView("Loading orders...")
                } else if orders.isEmpty {
                    emptyState
                } else {
                    ordersList
                }
            }
            .navigationTitle("Pickup Orders")
            .task {
                await loadOrders()
            }
            .refreshable {
                await loadOrders()
            }
            .sheet(item: $selectedOrder) { order in
                OrderDetailSheet(
                    apiBaseURL: apiBaseURL,
                    order: order
                ) {
                    await loadOrders()
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "tray")
                .font(.system(size: 50))
                .foregroundStyle(.tertiary)

            Text("No Pickup Orders")
                .font(.headline)

            Text("Online orders for pickup\nwill appear here")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }

    private var ordersList: some View {
        List(orders) { order in
            Button {
                selectedOrder = order
            } label: {
                OrderRowView(order: order)
            }
            .buttonStyle(.plain)
        }
        .listStyle(.plain)
    }

    @MainActor
    private func loadOrders() async {
        do {
            let client = try APIClient(baseURLString: apiBaseURL)
            orders = try await client.getActiveBopisOrders(storeId: storeId)
        } catch {
            // Fallback to mock data when API is unavailable
            orders = MockData.bopisOrders.filter { $0.status != "PICKED_UP" && $0.status != "CANCELLED" }
        }
        isLoading = false
    }
}

// MARK: - Order Row

struct OrderRowView: View {
    let order: BopisOrderResponse

    var body: some View {
        HStack(spacing: 12) {
            // Status Icon
            statusIcon
                .frame(width: 44, height: 44)
                .background(statusColor.opacity(0.15))
                .clipShape(Circle())

            // Order Info
            VStack(alignment: .leading, spacing: 4) {
                Text(order.orderNumber)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Text(order.customerName)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text("\(order.totalItems) item\(order.totalItems == 1 ? "" : "s")")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }

            Spacer()

            // Status Badge
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
        switch order.status {
        case "NEW": return "bell.badge"
        case "PREPARING": return "hand.raised"
        case "READY": return "checkmark.circle"
        default: return "shippingbox"
        }
    }

    private var statusText: String {
        switch order.status {
        case "NEW": return "New"
        case "PREPARING": return "Preparing"
        case "READY": return "Ready"
        case "PICKED_UP": return "Picked Up"
        default: return order.status
        }
    }

    private var statusColor: Color {
        switch order.status {
        case "NEW": return Color(red: 0.55, green: 0.75, blue: 0.75)
        case "PREPARING": return Color(red: 0.88, green: 0.82, blue: 0.72)
        case "READY": return Color(red: 0.65, green: 0.78, blue: 0.68)
        default: return .gray
        }
    }
}

// MARK: - Order Detail Sheet

struct OrderDetailSheet: View {
    let apiBaseURL: String
    let order: BopisOrderResponse
    let onUpdate: () async -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var isUpdating = false

    var body: some View {
        NavigationStack {
            List {
                // Customer Section
                Section("Customer") {
                    LabeledContent("Name", value: order.customerName)

                    if let email = order.customerEmail {
                        LabeledContent("Email", value: email)
                    }

                    if let phone = order.customerPhone {
                        LabeledContent("Phone", value: phone)
                    }
                }

                // Items Section
                Section("Items (\(order.totalItems))") {
                    ForEach(order.items) { item in
                        HStack(spacing: 12) {
                            AsyncImage(url: URL(string: item.productImageUrl ?? "")) { phase in
                                if case .success(let image) = phase {
                                    image.resizable().aspectRatio(contentMode: .fill)
                                } else {
                                    Image(systemName: "tshirt").foregroundStyle(.secondary)
                                }
                            }
                            .frame(width: 44, height: 44)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 6))

                            VStack(alignment: .leading) {
                                Text(item.productName)
                                    .font(.subheadline)
                                Text(item.productSku)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Text("×\(item.quantity)")
                                .font(.headline)
                        }
                    }
                }

                // Action Section
                Section {
                    actionButton
                }
            }
            .navigationTitle(order.orderNumber)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    @ViewBuilder
    private var actionButton: some View {
        switch order.status {
        case "NEW":
            Button {
                Task { await markPreparing() }
            } label: {
                HStack {
                    if isUpdating {
                        ProgressView().tint(.white)
                    } else {
                        Image(systemName: "hand.raised")
                        Text("Start Preparing")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
            .buttonStyle(.borderedProminent)
            .tint(Color(red: 0.88, green: 0.82, blue: 0.72))
            .disabled(isUpdating)

        case "PREPARING":
            Button {
                Task { await markReady() }
            } label: {
                HStack {
                    if isUpdating {
                        ProgressView().tint(.white)
                    } else {
                        Image(systemName: "checkmark.circle")
                        Text("Mark as Ready")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
            .buttonStyle(.borderedProminent)
            .tint(Color(red: 0.65, green: 0.78, blue: 0.68))
            .disabled(isUpdating)

        case "READY":
            Button {
                Task { await markPickedUp() }
            } label: {
                HStack {
                    if isUpdating {
                        ProgressView().tint(.white)
                    } else {
                        Image(systemName: "person.badge.checkmark")
                        Text("Customer Picked Up")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
            .buttonStyle(.borderedProminent)
            .disabled(isUpdating)

        default:
            EmptyView()
        }
    }

    @MainActor
    private func markPreparing() async {
        isUpdating = true
        do {
            let client = try APIClient(baseURLString: apiBaseURL)
            _ = try await client.markOrderPreparing(orderId: Int(order.id))
            await onUpdate()
            dismiss()
        } catch {}
        isUpdating = false
    }

    @MainActor
    private func markReady() async {
        isUpdating = true
        do {
            let client = try APIClient(baseURLString: apiBaseURL)
            _ = try await client.markOrderReady(orderId: Int(order.id))
            await onUpdate()
            dismiss()
        } catch {}
        isUpdating = false
    }

    @MainActor
    private func markPickedUp() async {
        isUpdating = true
        do {
            let client = try APIClient(baseURLString: apiBaseURL)
            _ = try await client.markOrderPickedUp(orderId: Int(order.id))
            await onUpdate()
            dismiss()
        } catch {}
        isUpdating = false
    }
}

#Preview {
    OrdersView(apiBaseURL: "http://localhost:8080", storeId: 1)
}
