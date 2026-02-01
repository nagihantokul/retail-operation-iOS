import SwiftUI

// MARK: - Pastel Color Palette

extension Color {
    // Sage green tones
    static let pastelSage = Color(red: 0.65, green: 0.78, blue: 0.68)
    static let pastelMint = Color(red: 0.70, green: 0.85, blue: 0.78)
    static let pastelTeal = Color(red: 0.55, green: 0.75, blue: 0.75)

    // Soft neutrals
    static let pastelSlate = Color(red: 0.55, green: 0.62, blue: 0.70)
    static let pastelStone = Color(red: 0.72, green: 0.70, blue: 0.68)

    // Accent colors (softer)
    static let pastelCoral = Color(red: 0.90, green: 0.65, blue: 0.60)
    static let pastelSand = Color(red: 0.88, green: 0.82, blue: 0.72)
    static let pastelLavender = Color(red: 0.75, green: 0.72, blue: 0.82)
}

// MARK: - Main Home View (Dashboard)

struct HomeView: View {
    let apiBaseURL: String
    @Binding var currentStoreId: Int
    @Binding var currentStoreName: String
    @ObservedObject var locationManager: LocationManager

    @EnvironmentObject private var customerStore: CustomerStore
    @EnvironmentObject private var salesStore: SalesStore

    @State private var searchText = ""
    @State private var isShowingScanner = false
    @State private var searchResults: [ProductSearchResult] = []
    @State private var isSearching = false
    @State private var showStoreSelector = false
    @State private var showCheckout = false
    @State private var showClienteling = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Store Selection Header
                    storeHeader

                    if currentStoreId == 0 {
                        emptyStateView
                    } else {
                        // Search Bar
                        searchBar

                        // Search Results or Dashboard
                        if isSearching {
                            ProgressView("Searching...")
                                .padding(.vertical, 40)
                        } else if !searchResults.isEmpty {
                            resultsList
                        } else {
                            dashboardContent
                        }
                    }
                }
                .padding(.bottom, 20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Sales Associate")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $isShowingScanner) {
                scannerSheet
            }
            .sheet(isPresented: $showStoreSelector) {
                storePickerSheet
            }
            .sheet(isPresented: $showCheckout) {
                NavigationStack {
                    CheckoutView(
                        apiBaseURL: apiBaseURL,
                        currentStoreId: $currentStoreId,
                        currentStoreName: $currentStoreName,
                        locationManager: locationManager
                    )
                }
                .environmentObject(customerStore)
                .environmentObject(salesStore)
            }
            .sheet(isPresented: $showClienteling) {
                CustomersView()
                    .environmentObject(customerStore)
                    .environmentObject(salesStore)
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
                    .frame(height: 120)
                    .clipped()

                LinearGradient(
                    colors: [.clear, .black.opacity(0.85)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 120)

                HStack(spacing: 12) {
                    Image(systemName: "building.2.fill")
                        .font(.title3)
                        .foregroundStyle(.white)
                        .frame(width: 40, height: 40)
                        .background(.white.opacity(0.18))
                        .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 2) {
                        Text(currentStoreId == 0 ? "Select Store" : currentStoreName)
                            .font(.headline)
                            .foregroundStyle(.white)
                            .lineLimit(1)

                        Text(currentStoreId == 0 ? "Tap to choose your store" : "Tap to change store")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.8))
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.9))
                }
                .padding()
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.15), radius: 10, y: 4)
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
    }

    // MARK: - Empty State

    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer().frame(height: 60)

            Image(systemName: "building.2")
                .font(.system(size: 60))
                .foregroundStyle(.tertiary)

            Text("Select a Store")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Choose your store to access\nall associate tools")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button(action: { showStoreSelector = true }) {
                Text("Select Store")
                    .fontWeight(.semibold)
                    .frame(width: 180)
                    .padding(.vertical, 14)
                    .background(Color.pastelSage)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Spacer()
        }
        .padding()
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)

                TextField("Search product, SKU, or barcode", text: $searchText)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .onSubmit { Task { await search() } }

                if !searchText.isEmpty {
                    Button(action: clearSearch) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding(12)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Button(action: { isShowingScanner = true }) {
                Image(systemName: "barcode.viewfinder")
                    .font(.title2)
                    .frame(width: 48, height: 48)
                    .background(Color.pastelTeal)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Dashboard Content

    private var dashboardContent: some View {
        VStack(spacing: 20) {
            // Primary Actions Grid
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                // Mobile Checkout
                ActionCard(
                    icon: "creditcard.fill",
                    title: "Checkout",
                    subtitle: "Mobile POS",
                    color: .pastelSage
                ) {
                    showCheckout = true
                }

                // Scan Product
                ActionCard(
                    icon: "barcode.viewfinder",
                    title: "Scan",
                    subtitle: "Product lookup",
                    color: .pastelTeal
                ) {
                    isShowingScanner = true
                }

                // BOPIS Orders
                NavigationLink {
                    OrdersView(apiBaseURL: apiBaseURL, storeId: currentStoreId)
                } label: {
                    ActionCardLabel(
                        icon: "shippingbox.fill",
                        title: "Orders",
                        subtitle: "BOPIS pickup",
                        color: .pastelSand
                    )
                }
                .buttonStyle(.plain)

                // Clienteling
                ActionCard(
                    icon: "person.2.fill",
                    title: "Customers",
                    subtitle: "Clienteling",
                    color: .pastelSlate
                ) {
                    showClienteling = true
                }
            }
            .padding(.horizontal)

            // Inventory Section
            VStack(alignment: .leading, spacing: 12) {
                Text("Inventory")
                    .font(.headline)
                    .padding(.horizontal)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    NavigationLink {
                        AlertsListView()
                    } label: {
                        SmallActionCard(icon: "exclamationmark.triangle.fill", title: "Low Stock", color: .pastelCoral)
                    }
                    .buttonStyle(.plain)

                    NavigationLink {
                        TransfersView(storeId: currentStoreId)
                    } label: {
                        SmallActionCard(icon: "arrow.left.arrow.right", title: "Transfers", color: .pastelMint)
                    }
                    .buttonStyle(.plain)

                    NavigationLink {
                        InventoryCountView(storeId: currentStoreId)
                    } label: {
                        SmallActionCard(icon: "list.clipboard.fill", title: "Count", color: .pastelLavender)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal)
            }

            // AI Assistant Section
            VStack(alignment: .leading, spacing: 12) {
                Text("AI Assistant")
                    .font(.headline)
                    .padding(.horizontal)

                NavigationLink {
                    AIAssistantView(storeId: currentStoreId)
                } label: {
                    HStack(spacing: 16) {
                        Image(systemName: "sparkles")
                            .font(.title2)
                            .foregroundStyle(.white)
                            .frame(width: 50, height: 50)
                            .background(
                                LinearGradient(colors: [.pastelTeal, .pastelSage], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 12))

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Ask Associate AI")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.primary)

                            Text("Product recommendations, alternatives, styling tips")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(.plain)
                .padding(.horizontal)
            }

            // Quick Stats
            VStack(alignment: .leading, spacing: 12) {
                Text("Today's Overview")
                    .font(.headline)
                    .padding(.horizontal)

                HStack(spacing: 12) {
                    StatCard(value: "12", label: "Orders", icon: "bag.fill", color: .pastelTeal)
                    StatCard(value: "3", label: "Low Stock", icon: "exclamationmark.circle.fill", color: .pastelCoral)
                    StatCard(value: "5", label: "Transfers", icon: "arrow.triangle.swap", color: .pastelSage)
                }
                .padding(.horizontal)
            }
        }
    }

    // MARK: - Results List

    private var resultsList: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Results")
                    .font(.headline)
                Spacer()
                Button("Clear") { clearSearch() }
                    .font(.subheadline)
            }
            .padding(.horizontal)

            LazyVStack(spacing: 12) {
                ForEach(searchResults) { product in
                    NavigationLink {
                        ProductDetailView(
                            apiBaseURL: apiBaseURL,
                            product: product,
                            currentStoreId: currentStoreId
                        )
                    } label: {
                        ProductRowView(product: product)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Sheets

    private var scannerSheet: some View {
        NavigationStack {
            BarcodeScannerView { code in
                isShowingScanner = false
                searchText = code
                Task { await search() }
            } onError: { _ in
                isShowingScanner = false
            }
            .navigationTitle("Scan Barcode")
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

    // MARK: - Actions

    private func clearSearch() {
        searchText = ""
        searchResults = []
    }

    @MainActor
    private func search() async {
        let query = searchText.trimmingCharacters(in: .whitespaces)
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
}

// MARK: - Action Card

struct ActionCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ActionCardLabel(icon: icon, title: title, subtitle: subtitle, color: color)
        }
        .buttonStyle(.plain)
    }
}

struct ActionCardLabel: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)

                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
    }
}

struct SmallActionCard: View {
    let icon: String
    let title: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)

            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.03), radius: 3, y: 1)
    }
}

struct StatCard: View {
    let value: String
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundStyle(color)
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
            }

            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

// MARK: - Product Row

struct ProductRowView: View {
    let product: ProductSearchResult

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: product.imageUrl ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure, .empty:
                    Image(systemName: "tshirt")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                @unknown default:
                    Image(systemName: "tshirt")
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 64, height: 64)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(2)

                Text(product.sku)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                if let category = product.category {
                    Text(category)
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color(.systemGray5))
                        .clipShape(Capsule())
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text("\(product.quantity)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(stockColor)

                Text("in stock")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(12)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var stockColor: Color {
        if product.quantity == 0 { return .red }
        if product.quantity < 10 { return .orange }
        return .primary
    }
}

// MARK: - Product Search Result Model

struct ProductSearchResult: Identifiable, Decodable, Hashable {
    let id: Int64
    let sku: String
    let name: String
    let barcode: String?
    let category: String?
    let price: Double?
    let imageUrl: String?
    let quantity: Int
}

// MARK: - Preview

#Preview {
    HomeView(
        apiBaseURL: "http://localhost:8080",
        currentStoreId: .constant(1),
        currentStoreName: .constant("Union Square"),
        locationManager: LocationManager()
    )
    .environmentObject(CustomerStore())
    .environmentObject(SalesStore())
}
