import SwiftUI

struct ProductDetailView: View {
    let apiBaseURL: String
    let product: ProductSearchResult
    let currentStoreId: Int

    @State private var currentQuantity: Int
    @State private var availability: ProductAvailabilityResponse?
    @State private var isLoadingStores = true
    @State private var showAdjustSheet = false
    @State private var showTransferSheet = false
    @State private var selectedSourceStore: StoreAvailabilityResponse?

    init(apiBaseURL: String, product: ProductSearchResult, currentStoreId: Int) {
        self.apiBaseURL = apiBaseURL
        self.product = product
        self.currentStoreId = currentStoreId
        self._currentQuantity = State(initialValue: product.quantity)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Product Image
                productImage

                // Stock Section
                stockSection

                // Product Info
                productInfo

                // Other Stores
                otherStoresSection
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(product.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAdjustSheet) {
            StockAdjustmentView(
                apiBaseURL: apiBaseURL,
                product: product,
                currentQuantity: currentQuantity,
                storeId: currentStoreId
            ) { newQuantity in
                currentQuantity = newQuantity
            }
        }
        .sheet(isPresented: $showTransferSheet) {
            if let sourceStore = selectedSourceStore {
                TransferRequestSheet(
                    apiBaseURL: apiBaseURL,
                    product: product,
                    sourceStore: sourceStore,
                    destinationStoreId: currentStoreId
                )
            }
        }
        .task {
            await loadAvailability()
        }
    }

    // MARK: - Product Image

    private var productImage: some View {
        AsyncImage(url: URL(string: product.imageUrl ?? "")) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            case .failure, .empty:
                VStack(spacing: 12) {
                    Image(systemName: "tshirt.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(.tertiary)
                    Text("No Image")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            @unknown default:
                ProgressView()
            }
        }
        .frame(height: 240)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Stock Section

    private var stockSection: some View {
        VStack(spacing: 16) {
            // Stock Count
            VStack(spacing: 4) {
                Text("\(currentQuantity)")
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .foregroundStyle(stockColor)

                Text("units in stock")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            // Adjust Button
            Button(action: { showAdjustSheet = true }) {
                HStack {
                    Image(systemName: "plusminus")
                    Text("Adjust Stock")
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color(red: 0.55, green: 0.75, blue: 0.68))
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var stockColor: Color {
        if currentQuantity == 0 { return Color(red: 0.90, green: 0.65, blue: 0.60) }
        if currentQuantity < 10 { return Color(red: 0.88, green: 0.82, blue: 0.72) }
        return .primary
    }

    // MARK: - Product Info

    private var productInfo: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Product Details")
                .font(.headline)
                .padding(.bottom, 4)

            infoRow(label: "SKU", value: product.sku)

            if let barcode = product.barcode {
                infoRow(label: "Barcode", value: barcode)
            }

            if let category = product.category {
                infoRow(label: "Category", value: category)
            }

            if let price = product.price {
                infoRow(label: "Price", value: String(format: "$%.2f", price))
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
        .font(.subheadline)
    }

    // MARK: - Other Stores

    private var otherStoresSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Other Stores")
                    .font(.headline)
                Spacer()
                if currentQuantity < 10 {
                    Text("Tap to request")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.bottom, 4)

            if isLoadingStores {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .padding(.vertical)
            } else if let stores = availability?.stores, !stores.isEmpty {
                ForEach(stores) { store in
                    if store.current {
                        storeRow(store: store)
                    } else {
                        Button {
                            selectedSourceStore = store
                            showTransferSheet = true
                        } label: {
                            storeRow(store: store)
                        }
                        .buttonStyle(.plain)
                        .disabled(store.quantity == 0)
                    }

                    if store.id != stores.last?.id {
                        Divider()
                    }
                }
            } else {
                Text("No data available")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.vertical)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func storeRow(store: StoreAvailabilityResponse) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(store.name)
                        .font(.subheadline)
                        .fontWeight(store.current ? .semibold : .regular)

                    if store.current {
                        Text("Current")
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color(red: 0.55, green: 0.75, blue: 0.75).opacity(0.15))
                            .foregroundStyle(Color(red: 0.55, green: 0.75, blue: 0.75))
                            .clipShape(Capsule())
                    }
                }

                if let city = store.city {
                    Text(city)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            Text("\(store.quantity)")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(storeStockColor(quantity: Int(store.quantity)))

            if !store.current && store.quantity > 0 {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
    }

    private func storeStockColor(quantity: Int) -> Color {
        if quantity == 0 { return Color(red: 0.90, green: 0.65, blue: 0.60) }
        if quantity < 10 { return Color(red: 0.88, green: 0.82, blue: 0.72) }
        return Color(red: 0.65, green: 0.78, blue: 0.68)
    }

    // MARK: - Data Loading

    @MainActor
    private func loadAvailability() async {
        guard product.barcode != nil else {
            isLoadingStores = false
            return
        }

        do {
            let client = try APIClient(baseURLString: apiBaseURL)
            availability = try await client.availabilityByBarcode(
                barcode: product.barcode!,
                storeId: currentStoreId,
                limit: 10
            )
        } catch {
            // Fallback to mock data when API is unavailable
            let mockStores = MockData.storeAvailability(for: product.id, currentStoreId: currentStoreId)
            availability = ProductAvailabilityResponse(
                product: ProductResponse(
                    id: product.id,
                    sku: product.sku,
                    name: product.name,
                    barcode: product.barcode,
                    category: product.category,
                    price: product.price,
                    createdAt: "",
                    updatedAt: ""
                ),
                stores: mockStores
            )
        }

        isLoadingStores = false
    }
}

// MARK: - Transfer Request Sheet (Endless Aisle)

struct TransferRequestSheet: View {
    let apiBaseURL: String
    let product: ProductSearchResult
    let sourceStore: StoreAvailabilityResponse
    let destinationStoreId: Int

    @Environment(\.dismiss) private var dismiss

    @State private var quantity = 1
    @State private var isSubmitting = false
    @State private var showSuccess = false
    @State private var errorMessage: String?

    private var maxQuantity: Int {
        Int(sourceStore.quantity)
    }

    var body: some View {
        NavigationStack {
            if showSuccess {
                successView
            } else {
                formView
            }
        }
    }

    private var formView: some View {
        Form {
            Section {
                HStack(spacing: 12) {
                    AsyncImage(url: URL(string: product.imageUrl ?? "")) { phase in
                        if case .success(let image) = phase {
                            image.resizable().aspectRatio(contentMode: .fill)
                        } else {
                            Image(systemName: "tshirt").foregroundStyle(.secondary)
                        }
                    }
                    .frame(width: 50, height: 50)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                    VStack(alignment: .leading) {
                        Text(product.name)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Text(product.sku)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Section("Transfer From") {
                HStack {
                    Image(systemName: "building.2")
                        .foregroundStyle(Color(red: 0.88, green: 0.82, blue: 0.72))
                    Text(sourceStore.name)
                    Spacer()
                    Text("\(sourceStore.quantity) available")
                        .foregroundStyle(.secondary)
                }
            }

            Section("Quantity to Request") {
                Stepper(value: $quantity, in: 1...maxQuantity) {
                    HStack {
                        Text("Quantity")
                        Spacer()
                        Text("\(quantity)")
                            .fontWeight(.semibold)
                    }
                }
            }

            if let error = errorMessage {
                Section {
                    Text(error)
                        .foregroundStyle(Color(red: 0.90, green: 0.65, blue: 0.60))
                        .font(.caption)
                }
            }
        }
        .navigationTitle("Request Stock")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Request") {
                    Task { await submitRequest() }
                }
                .disabled(isSubmitting)
            }
        }
    }

    private var successView: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 72))
                .foregroundStyle(Color(red: 0.65, green: 0.78, blue: 0.68))

            Text("Request Sent!")
                .font(.title2)
                .fontWeight(.semibold)

            Text("\(quantity) x \(product.name)\nrequested from \(sourceStore.name)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Spacer()

            Button("Done") { dismiss() }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color(red: 0.55, green: 0.75, blue: 0.68))
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding()
        }
        .navigationBarBackButtonHidden()
    }

    @MainActor
    private func submitRequest() async {
        isSubmitting = true
        errorMessage = nil

        do {
            let client = try APIClient(baseURLString: apiBaseURL)
            _ = try await client.createTransferRequest(
                fromStoreId: Int(sourceStore.storeId),
                toStoreId: destinationStoreId,
                productId: Int(product.id),
                quantity: quantity,
                notes: nil
            )
            showSuccess = true
        } catch {
            errorMessage = error.localizedDescription
        }

        isSubmitting = false
    }
}

#Preview {
    NavigationStack {
        ProductDetailView(
            apiBaseURL: "http://localhost:8080",
            product: ProductSearchResult(
                id: 1,
                sku: "TSH-CTN-WHT",
                name: "Cotton T-Shirt - White",
                barcode: "8901234567892",
                category: "T-Shirts",
                price: 19.90,
                imageUrl: nil,
                quantity: 25
            ),
            currentStoreId: 1
        )
    }
}
