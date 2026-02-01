import SwiftUI

// MARK: - Adjustment Reasons

enum AdjustmentReason: String, CaseIterable, Identifiable {
    case sold = "Sold"
    case received = "Received"
    case returned = "Returned"
    case damaged = "Damaged"
    case correction = "Correction"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .sold: return "cart"
        case .received: return "shippingbox"
        case .returned: return "arrow.uturn.backward"
        case .damaged: return "exclamationmark.triangle"
        case .correction: return "pencil"
        }
    }

    var defaultDirection: Bool {
        switch self {
        case .sold, .damaged: return false  // Remove
        case .received, .returned, .correction: return true  // Add
        }
    }
}

// MARK: - Stock Adjustment View

struct StockAdjustmentView: View {
    let apiBaseURL: String
    let product: ProductSearchResult
    let currentQuantity: Int
    let storeId: Int
    let onComplete: (Int) -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var selectedReason: AdjustmentReason = .sold
    @State private var quantity: Int = 1
    @State private var isAdding: Bool = false
    @State private var isSubmitting = false
    @State private var errorMessage: String?

    private var delta: Int {
        isAdding ? quantity : -quantity
    }

    private var newQuantity: Int {
        currentQuantity + delta
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Form {
                    // Product Info
                    Section {
                        HStack(spacing: 12) {
                            AsyncImage(url: URL(string: product.imageUrl ?? "")) { phase in
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

                            VStack(alignment: .leading, spacing: 2) {
                                Text(product.name)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Text("Current: \(currentQuantity) in stock")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }

                    // Reason Selection
                    Section("Reason") {
                        ForEach(AdjustmentReason.allCases) { reason in
                            Button {
                                selectedReason = reason
                                isAdding = reason.defaultDirection
                            } label: {
                                HStack {
                                    Image(systemName: reason.icon)
                                        .frame(width: 24)
                                        .foregroundStyle(.secondary)

                                    Text(reason.rawValue)
                                        .foregroundStyle(.primary)

                                    Spacer()

                                    if selectedReason == reason {
                                        Image(systemName: "checkmark")
                                            .foregroundStyle(Color(red: 0.55, green: 0.75, blue: 0.68))
                                    }
                                }
                            }
                        }
                    }

                    // Quantity
                    Section("Quantity") {
                        Picker("Direction", selection: $isAdding) {
                            Text("Remove (-)").tag(false)
                            Text("Add (+)").tag(true)
                        }
                        .pickerStyle(.segmented)

                        Stepper(value: $quantity, in: 1...999) {
                            HStack {
                                Text("Amount")
                                Spacer()
                                Text("\(quantity)")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(isAdding ? Color(red: 0.65, green: 0.78, blue: 0.68) : Color(red: 0.90, green: 0.65, blue: 0.60))
                            }
                        }
                    }

                    // Preview
                    Section {
                        HStack {
                            Text("New Stock Level")
                            Spacer()
                            Text("\(newQuantity)")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(newQuantity < 0 ? Color(red: 0.90, green: 0.65, blue: 0.60) : newQuantity < 10 ? Color(red: 0.88, green: 0.82, blue: 0.72) : .primary)
                        }
                    }

                    // Error
                    if let error = errorMessage {
                        Section {
                            Text(error)
                                .foregroundStyle(Color(red: 0.90, green: 0.65, blue: 0.60))
                                .font(.caption)
                        }
                    }
                }

                // Save Button
                VStack {
                    Button(action: { Task { await submit() } }) {
                        if isSubmitting {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Save Adjustment")
                        }
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(newQuantity < 0 ? Color.gray : Color(red: 0.55, green: 0.75, blue: 0.68))
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .disabled(isSubmitting || newQuantity < 0)
                }
                .padding()
                .background(Color(.systemGroupedBackground))
            }
            .navigationTitle("Adjust Stock")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    @MainActor
    private func submit() async {
        isSubmitting = true
        errorMessage = nil

        do {
            let client = try APIClient(baseURLString: apiBaseURL)
            try await client.adjustInventory(
                storeId: storeId,
                productId: Int(product.id),
                delta: delta,
                reason: selectedReason.rawValue
            )
            onComplete(newQuantity)
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }

        isSubmitting = false
    }
}

#Preview {
    StockAdjustmentView(
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
        currentQuantity: 25,
        storeId: 1
    ) { _ in }
}
