import SwiftUI

// MARK: - Inventory Count View (Cycle Count)

struct InventoryCountView: View {
    let storeId: Int

    @AppStorage("apiBaseURL") private var apiBaseURL = "http://localhost:8080"

    @State private var countSession: CountSession?
    @State private var scannedItems: [CountedItem] = []
    @State private var isShowingScanner = false
    @State private var showStartCount = true

    var body: some View {
        Group {
            if showStartCount && countSession == nil {
                startCountView
            } else {
                countingView
            }
        }
        .navigationTitle("Inventory Count")
        .sheet(isPresented: $isShowingScanner) {
            scannerSheet
        }
    }

    private var startCountView: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "list.clipboard.fill")
                .font(.system(size: 60))
                .foregroundStyle(Color(red: 0.75, green: 0.72, blue: 0.82))

            Text("Cycle Count")
                .font(.title2)
                .fontWeight(.bold)

            Text("Verify inventory levels by scanning\nproducts in your store")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            VStack(spacing: 12) {
                Button(action: startFullCount) {
                    HStack {
                        Image(systemName: "square.grid.3x3.fill")
                        Text("Full Store Count")
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(red: 0.75, green: 0.72, blue: 0.82))
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                Button(action: startCategoryCount) {
                    HStack {
                        Image(systemName: "folder.fill")
                        Text("Category Count")
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(.systemGray5))
                    .foregroundStyle(.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                Button(action: startSpotCheck) {
                    HStack {
                        Image(systemName: "target")
                        Text("Spot Check")
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(.systemGray5))
                    .foregroundStyle(.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(.horizontal, 32)

            Spacer()
        }
        .padding()
    }

    private var countingView: some View {
        VStack(spacing: 0) {
            // Stats Header
            HStack(spacing: 16) {
                StatBox(value: "\(scannedItems.count)", label: "Scanned", color: Color(red: 0.55, green: 0.75, blue: 0.75))
                StatBox(value: "\(discrepancyCount)", label: "Discrepancies", color: discrepancyCount > 0 ? Color(red: 0.90, green: 0.65, blue: 0.60) : Color(red: 0.65, green: 0.78, blue: 0.68))
            }
            .padding()

            // Scanned Items List
            if scannedItems.isEmpty {
                Spacer()
                VStack(spacing: 16) {
                    Image(systemName: "barcode.viewfinder")
                        .font(.system(size: 50))
                        .foregroundStyle(.tertiary)
                    Text("Scan products to count")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            } else {
                List {
                    ForEach(scannedItems) { item in
                        CountedItemRow(item: item) { newCount in
                            updateCount(for: item.id, count: newCount)
                        }
                    }
                }
                .listStyle(.plain)
            }

            // Bottom Actions
            VStack(spacing: 12) {
                Button(action: { isShowingScanner = true }) {
                    HStack {
                        Image(systemName: "barcode.viewfinder")
                        Text("Scan Product")
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(red: 0.55, green: 0.75, blue: 0.75))
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                if !scannedItems.isEmpty {
                    Button(action: submitCount) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Submit Count")
                        }
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(red: 0.65, green: 0.78, blue: 0.68))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
            .padding()
            .background(Color(.systemGroupedBackground))
        }
    }

    private var scannerSheet: some View {
        NavigationStack {
            BarcodeScannerView { code in
                isShowingScanner = false
                addScannedProduct(barcode: code)
            } onError: { _ in
                isShowingScanner = false
            }
            .navigationTitle("Scan Product")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isShowingScanner = false }
                }
            }
        }
    }

    private var discrepancyCount: Int {
        scannedItems.filter { $0.actualCount != $0.expectedCount }.count
    }

    // MARK: - Actions

    private func startFullCount() {
        countSession = CountSession(type: .full)
        showStartCount = false
    }

    private func startCategoryCount() {
        countSession = CountSession(type: .category)
        showStartCount = false
    }

    private func startSpotCheck() {
        countSession = CountSession(type: .spotCheck)
        showStartCount = false
    }

    private func addScannedProduct(barcode: String) {
        if let product = MockData.products.first(where: { $0.barcode == barcode }) {
            // Check if already scanned
            if scannedItems.contains(where: { $0.productId == product.id }) {
                return
            }

            scannedItems.append(CountedItem(
                productId: product.id,
                productName: product.name,
                productSku: product.sku,
                imageUrl: product.imageUrl,
                expectedCount: product.quantity,
                actualCount: 0
            ))
        }
    }

    private func updateCount(for id: UUID, count: Int) {
        if let index = scannedItems.firstIndex(where: { $0.id == id }) {
            scannedItems[index].actualCount = count
        }
    }

    private func submitCount() {
        // Submit count would go here
        showStartCount = true
        countSession = nil
        scannedItems.removeAll()
    }
}

// MARK: - Supporting Types

struct CountSession {
    enum CountType {
        case full, category, spotCheck
    }
    let type: CountType
    let startedAt = Date()
}

struct CountedItem: Identifiable {
    let id = UUID()
    let productId: Int64
    let productName: String
    let productSku: String
    let imageUrl: String?
    let expectedCount: Int
    var actualCount: Int
}

struct StatBox: View {
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(color)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct CountedItemRow: View {
    let item: CountedItem
    let onCountChange: (Int) -> Void

    @State private var countText: String = ""

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: item.imageUrl ?? "")) { phase in
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

            VStack(alignment: .leading, spacing: 4) {
                Text(item.productName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)

                Text(item.productSku)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                HStack(spacing: 8) {
                    Text("Expected: \(item.expectedCount)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)

                    if item.actualCount > 0 && item.actualCount != item.expectedCount {
                        Text(item.actualCount > item.expectedCount ? "+\(item.actualCount - item.expectedCount)" : "\(item.actualCount - item.expectedCount)")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundStyle(item.actualCount > item.expectedCount ? Color(red: 0.55, green: 0.75, blue: 0.75) : Color(red: 0.90, green: 0.65, blue: 0.60))
                    }
                }
            }

            Spacer()

            HStack(spacing: 8) {
                Button {
                    onCountChange(max(0, item.actualCount - 1))
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }

                Text("\(item.actualCount)")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .frame(minWidth: 40)

                Button {
                    onCountChange(item.actualCount + 1)
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(Color(red: 0.55, green: 0.75, blue: 0.68))
                }
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    NavigationStack {
        InventoryCountView(storeId: 1)
    }
}
