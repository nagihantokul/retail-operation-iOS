import SwiftUI

struct CheckoutCartItem: Identifiable, Hashable {
    var id: Int64 { product.id }
    let product: ProductSearchResult
    var quantity: Int

    var unitPriceCents: Int {
        Money.cents(from: product.price ?? 0)
    }

    var lineTotalCents: Int {
        unitPriceCents * quantity
    }
}

private struct CheckoutAlert: Identifiable {
    let id = UUID()
    let title: String
    let message: String
}

struct CheckoutView: View {
    let apiBaseURL: String
    @Binding var currentStoreId: Int
    @Binding var currentStoreName: String
    @ObservedObject var locationManager: LocationManager

    @AppStorage("checkoutCustomerId") private var checkoutCustomerId = ""
    @AppStorage("checkoutTaxRate") private var checkoutTaxRate = 0.0825

    @EnvironmentObject private var customerStore: CustomerStore
    @EnvironmentObject private var salesStore: SalesStore

    @State private var selectedCustomer: Customer?

    @State private var searchText = ""
    @State private var searchResults: [ProductSearchResult] = []
    @State private var isSearching = false
    @State private var isShowingScanner = false
    @State private var showStoreSelector = false
    @State private var showCustomerPicker = false

    @State private var cart: [CheckoutCartItem] = []
    @State private var showCheckoutSheet = false

    @State private var alert: CheckoutAlert?

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 16) {
                        storeHeader
                        customerCard
                        searchSection

                        if !searchResults.isEmpty {
                            resultsSection
                        }

                        cartSection
                    }
                    .padding(.vertical, 12)
                }

                checkoutFooter
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Checkout")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isShowingScanner) {
                scannerSheet
            }
            .sheet(isPresented: $showStoreSelector) {
                storePickerSheet
            }
            .sheet(isPresented: $showCustomerPicker) {
                customerPickerSheet
            }
            .sheet(isPresented: $showCheckoutSheet) {
                CheckoutSheetView(
                    apiBaseURL: apiBaseURL,
                    storeId: currentStoreId,
                    storeName: currentStoreName.isEmpty ? "#\(currentStoreId)" : currentStoreName,
                    customer: selectedCustomer,
                    cartItems: cart,
                    taxRate: checkoutTaxRate
                ) { receipt in
                    salesStore.add(receipt)
                    cart.removeAll()
                    searchText = ""
                    searchResults = []
                }
            }
            .alert(item: $alert) { alert in
                Alert(title: Text(alert.title), message: Text(alert.message), dismissButton: .default(Text("OK")))
            }
            .task {
                syncSelectedCustomerFromStorage()
            }
        }
    }

    // MARK: - Store Header

    private var storeHeader: some View {
        Button(action: { showStoreSelector = true }) {
            ZStack(alignment: .bottomLeading) {
                Image("IMG_0227")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 110)
                    .clipped()

                LinearGradient(
                    colors: [.clear, .black.opacity(0.85)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 110)

                HStack(spacing: 12) {
                    Image(systemName: "building.2.fill")
                        .font(.title3)
                        .foregroundStyle(.white)
                        .frame(width: 36, height: 36)
                        .background(.white.opacity(0.18))
                        .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 2) {
                        Text(currentStoreId == 0 ? "Select Store" : currentStoreName)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)

                        Text(currentStoreId == 0 ? "Tap to choose your store" : "Tap to change")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.85))
                            .lineLimit(1)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.9))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.12), radius: 8, y: 3)
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
    }

    // MARK: - Customer

    private var customerCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label("Customer", systemImage: "person.text.rectangle")
                    .font(.headline)
                Spacer()
                Button(selectedCustomer == nil ? "Select" : "Change") {
                    showCustomerPicker = true
                }
                .font(.subheadline)
            }

            if let customer = selectedCustomer {
                HStack(spacing: 12) {
                    Text(customer.initials)
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 40, height: 40)
                        .background(Color(red: 0.55, green: 0.62, blue: 0.70))
                        .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 2) {
                        Text(customer.displayName)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text([customer.email, customer.phone].compactMap { $0 }.joined(separator: " • "))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }

                    Spacer()

                    Button {
                        selectedCustomer = nil
                        checkoutCustomerId = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            } else {
                Text("Optional — helps with clienteling and purchase history.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(14)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }

    // MARK: - Search

    private var searchSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)

                    TextField("Search product / SKU / barcode", text: $searchText)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .onSubmit { Task { await search() } }

                    if !searchText.isEmpty {
                        Button(action: clearSearch) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.secondary)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(12)
                .background(.background)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                Button(action: { isShowingScanner = true }) {
                    Image(systemName: "barcode.viewfinder")
                        .font(.title2)
                        .frame(width: 48, height: 48)
                        .background(Color(red: 0.55, green: 0.75, blue: 0.75))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(currentStoreId == 0)
            }
            .disabled(currentStoreId == 0)

            if isSearching {
                HStack(spacing: 10) {
                    ProgressView()
                    Text("Searching…")
                        .foregroundStyle(.secondary)
                }
                .font(.subheadline)
            }
        }
        .padding(14)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }

    private var resultsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Results")
                .font(.headline)
                .padding(.horizontal)

            LazyVStack(spacing: 10) {
                ForEach(searchResults) { product in
                    Button {
                        addToCart(product)
                    } label: {
                        HStack(spacing: 12) {
                            AsyncImage(url: URL(string: product.imageUrl ?? "")) { phase in
                                if case .success(let image) = phase {
                                    image.resizable().aspectRatio(contentMode: .fill)
                                } else {
                                    Image(systemName: "tshirt")
                                        .font(.title2)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .frame(width: 48, height: 48)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 10))

                            VStack(alignment: .leading, spacing: 2) {
                                Text(product.name)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .lineLimit(2)
                                Text(product.sku)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            VStack(alignment: .trailing, spacing: 2) {
                                Text(Money.formatUSD(cents: Money.cents(from: product.price ?? 0)))
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Text("\(product.quantity) in stock")
                                    .font(.caption2)
                                    .foregroundStyle(product.quantity == 0 ? Color(red: 0.90, green: 0.65, blue: 0.60) : .secondary)
                            }

                            Image(systemName: "plus.circle.fill")
                                .font(.title3)
                                .foregroundStyle(product.quantity == 0 ? .gray : Color(red: 0.55, green: 0.75, blue: 0.68))
                                .padding(.leading, 6)
                        }
                        .padding(12)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .opacity(product.quantity == 0 ? 0.6 : 1)
                    }
                    .buttonStyle(.plain)
                    .disabled(product.quantity == 0 || currentStoreId == 0)
                }
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Cart

    private var cartSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Cart")
                    .font(.headline)
                Spacer()
                if !cart.isEmpty {
                    Button("Clear") { cart.removeAll() }
                        .font(.subheadline)
                }
            }
            .padding(.horizontal)

            if cart.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: "cart")
                        .font(.system(size: 42))
                        .foregroundStyle(.tertiary)
                    Text("Scan or search to add items.")
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)
            } else {
                LazyVStack(spacing: 10) {
                    ForEach(cart) { item in
                        CartRow(
                            item: item,
                            maxQuantity: max(1, item.product.quantity),
                            onUpdate: { qty in updateQuantity(itemId: item.id, quantity: qty) },
                            onRemove: { removeFromCart(itemId: item.id) }
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    private var checkoutFooter: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(Money.formatUSD(cents: totalCents))
                        .font(.title2)
                        .fontWeight(.bold)
                }
                Spacer()
                Button {
                    showCheckoutSheet = true
                } label: {
                    Text("Pay")
                        .fontWeight(.semibold)
                        .frame(width: 120)
                        .padding(.vertical, 12)
                        .background(canCheckout ? Color(red: 0.55, green: 0.75, blue: 0.68) : Color.gray)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .disabled(!canCheckout)
            }

            HStack {
                Text("Subtotal \(Money.formatUSD(cents: subtotalCents))")
                Spacer()
                Text("Tax \(Money.formatUSD(cents: taxCents))")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(14)
        .background(.ultraThinMaterial)
        .overlay(Divider(), alignment: .top)
    }

    private var canCheckout: Bool {
        currentStoreId != 0 && !cart.isEmpty
    }

    private var subtotalCents: Int {
        cart.reduce(0) { $0 + $1.lineTotalCents }
    }

    private var taxCents: Int {
        Int((Double(subtotalCents) * checkoutTaxRate).rounded())
    }

    private var totalCents: Int {
        subtotalCents + taxCents
    }

    // MARK: - Sheets

    private var scannerSheet: some View {
        NavigationStack {
            BarcodeScannerView { code in
                isShowingScanner = false
                searchText = code
                Task { await search() }
            } onError: { error in
                isShowingScanner = false
                alert = CheckoutAlert(title: "Scanner Error", message: error.localizedDescription)
            }
            .navigationTitle("Scan Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isShowingScanner = false }
                }
            }
        }
    }

    private var storePickerSheet: some View {
        NavigationStack {
            StorePickerView(
                apiBaseURL: apiBaseURL,
                locationManager: locationManager,
                selectedStoreId: $currentStoreId,
                selectedStoreName: $currentStoreName
            )
        }
    }

    private var customerPickerSheet: some View {
        NavigationStack {
            CustomerPickerView(
                customers: customerStore.customers,
                selectedCustomerId: selectedCustomer?.id
            ) { picked in
                selectedCustomer = picked
                checkoutCustomerId = picked?.id.uuidString ?? ""
                showCustomerPicker = false
            }
            .navigationTitle("Select Customer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { showCustomerPicker = false }
                }
            }
        }
    }

    // MARK: - Actions

    private func clearSearch() {
        searchText = ""
        searchResults = []
    }

    private func addToCart(_ product: ProductSearchResult) {
        guard currentStoreId != 0 else {
            alert = CheckoutAlert(title: "Select Store", message: "Choose a store before adding items.")
            return
        }
        guard product.quantity > 0 else {
            alert = CheckoutAlert(title: "Out of Stock", message: "This item is out of stock at the selected store.")
            return
        }

        if let index = cart.firstIndex(where: { $0.product.id == product.id }) {
            let next = cart[index].quantity + 1
            if next > product.quantity {
                alert = CheckoutAlert(title: "Stock Limit", message: "Only \(product.quantity) units available for this item.")
                return
            }
            cart[index].quantity = next
        } else {
            cart.append(CheckoutCartItem(product: product, quantity: 1))
        }
    }

    private func updateQuantity(itemId: Int64, quantity: Int) {
        guard let index = cart.firstIndex(where: { $0.id == itemId }) else { return }
        cart[index].quantity = max(1, quantity)
    }

    private func removeFromCart(itemId: Int64) {
        cart.removeAll { $0.id == itemId }
    }

    @MainActor
    private func search() async {
        guard currentStoreId != 0 else {
            alert = CheckoutAlert(title: "Select Store", message: "Choose a store before searching.")
            return
        }
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return }

        isSearching = true
        defer { isSearching = false }

        do {
            let client = try APIClient(baseURLString: apiBaseURL)
            searchResults = try await client.searchProducts(query: query, storeId: currentStoreId)
        } catch {
            searchResults = MockData.searchProducts(query: query)
        }
    }

    private func syncSelectedCustomerFromStorage() {
        guard selectedCustomer == nil, !checkoutCustomerId.isEmpty, let id = UUID(uuidString: checkoutCustomerId) else {
            return
        }
        selectedCustomer = customerStore.customer(id: id)
    }
}

private struct CartRow: View {
    let item: CheckoutCartItem
    let maxQuantity: Int
    let onUpdate: (Int) -> Void
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: item.product.imageUrl ?? "")) { phase in
                if case .success(let image) = phase {
                    image.resizable().aspectRatio(contentMode: .fill)
                } else {
                    Image(systemName: "tshirt")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 52, height: 52)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 2) {
                Text(item.product.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(2)
                Text(item.product.sku)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 8) {
                Text(Money.formatUSD(cents: item.lineTotalCents))
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Stepper(value: Binding(get: { item.quantity }, set: { onUpdate($0) }), in: 1...maxQuantity) {
                    Text("Qty \(item.quantity)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }
            }

            Button(action: onRemove) {
                Image(systemName: "trash")
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
        }
        .padding(12)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    CheckoutView(
        apiBaseURL: "http://localhost:8080",
        currentStoreId: .constant(1),
        currentStoreName: .constant("Union Square"),
        locationManager: LocationManager()
    )
    .environmentObject(CustomerStore())
    .environmentObject(SalesStore())
}
