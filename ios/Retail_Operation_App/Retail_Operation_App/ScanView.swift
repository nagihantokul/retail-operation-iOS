import CoreLocation
import SwiftUI

struct ScanView: View {
	let apiBaseURL: String
	let currentStoreId: Int
	let currentStoreName: String
	let radiusMi: Double
	@ObservedObject var locationManager: LocationManager

	@State private var manualBarcode = ""
	@State private var isShowingScanner = false
	@State private var isLoading = false
	@State private var errorMessage: String?
	@State private var availability: ProductAvailabilityResponse?

	var body: some View {
		Form {
			Section("Current Store") {
				if currentStoreId == 0 {
					Text("Select a store in the Stores tab to start scanning.")
						.foregroundStyle(.secondary)
				} else {
					LabeledContent("Store", value: currentStoreName.isEmpty ? "#\(currentStoreId)" : currentStoreName)
				}
			}

			Section("Barcode") {
				TextField("Enter barcode", text: $manualBarcode)
					.textInputAutocapitalization(.never)
					.autocorrectionDisabled()

				HStack {
					Button("Scan with Camera") { isShowingScanner = true }
						.disabled(currentStoreId == 0)
					Spacer()
					Button("Lookup") { Task { await lookup(barcode: manualBarcode) } }
						.disabled(currentStoreId == 0 || manualBarcode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
				}
			}

			if isLoading {
				Section {
					ProgressView("Loading…")
				}
			}

			if let errorMessage {
				Section {
					Text(errorMessage)
						.foregroundStyle(Color(red: 0.90, green: 0.65, blue: 0.60))
				}
			}

			if let availability {
				Section("Product") {
					Text(availability.product.name)
					LabeledContent("SKU", value: availability.product.sku)
					if let barcode = availability.product.barcode {
						LabeledContent("Barcode", value: barcode)
					}
					if let category = availability.product.category {
						LabeledContent("Category", value: category)
					}
				}

				Section("Availability") {
					ForEach(availability.stores) { store in
						HStack {
							VStack(alignment: .leading, spacing: 2) {
								Text(store.name)
								Text([store.city, store.state].compactMap { $0 }.joined(separator: ", "))
									.font(.footnote)
									.foregroundStyle(.secondary)
							}
							Spacer()
							if let distanceMi = store.distanceMi, !store.current {
								Text("\(distanceMi, format: .number.precision(.fractionLength(1))) mi")
									.font(.footnote)
									.foregroundStyle(.secondary)
									.monospacedDigit()
							}
							Text("\(store.quantity)")
								.font(.headline)
								.monospacedDigit()
								.padding(.leading, 8)
							if store.current {
								Image(systemName: "location.fill")
									.foregroundStyle(.tint)
							}
						}
					}
				}
			}
		}
		.navigationTitle("Scan")
		.sheet(isPresented: $isShowingScanner) {
			NavigationStack {
				BarcodeScannerView { code in
					isShowingScanner = false
					manualBarcode = code
					Task { await lookup(barcode: code) }
				} onError: { error in
					isShowingScanner = false
					errorMessage = error.localizedDescription
				}
				.navigationTitle("Scan Barcode")
				.toolbar {
					ToolbarItem(placement: .cancellationAction) {
						Button("Close") { isShowingScanner = false }
					}
				}
			}
		}
		.onAppear {
			if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
				locationManager.startUpdatingLocation()
			}
		}
	}

	@MainActor
	private func lookup(barcode: String) async {
		errorMessage = nil
		availability = nil
		isLoading = true
		defer { isLoading = false }

		do {
			let client = try APIClient(baseURLString: apiBaseURL)
			let loc = locationManager.lastLocation
			availability = try await client.availabilityByBarcode(
				barcode: barcode.trimmingCharacters(in: .whitespacesAndNewlines),
				storeId: currentStoreId,
				lat: loc?.coordinate.latitude,
				lng: loc?.coordinate.longitude,
				radiusMi: radiusMi,
				limit: 50
			)
		} catch {
			errorMessage = error.localizedDescription
		}
	}
}

#Preview {
	NavigationStack {
		ScanView(
			apiBaseURL: "http://localhost:8080",
			currentStoreId: 1,
			currentStoreName: "Store NYC",
			radiusMi: 10,
			locationManager: LocationManager()
		)
	}
}
