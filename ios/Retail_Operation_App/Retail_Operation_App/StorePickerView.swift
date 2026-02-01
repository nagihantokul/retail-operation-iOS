import CoreLocation
import SwiftUI

struct StorePickerView: View {
	let apiBaseURL: String
	@ObservedObject var locationManager: LocationManager

	@Binding var selectedStoreId: Int
	@Binding var selectedStoreName: String

	@Environment(\.dismiss) private var dismiss

	@State private var mode: Mode = .nearby
	@State private var city = ""
	@State private var state = ""
	@State private var stores: [StoreResponse] = []
	@State private var isLoading = false
	@State private var errorMessage: String?

	private enum Mode: String, CaseIterable, Identifiable {
		case nearby = "Nearby"
		case city = "City/State"

		var id: String { rawValue }
	}

	var body: some View {
		List {
			Section {
				Picker("Mode", selection: $mode) {
					ForEach(Mode.allCases) { mode in
						Text(mode.rawValue).tag(mode)
					}
				}
				.pickerStyle(.segmented)
			}

			if mode == .nearby {
				nearbySection
			} else {
				citySection
			}

			if let errorMessage {
				Section {
					Text(errorMessage)
						.foregroundStyle(.red)
				}
			}

			Section("Stores") {
				if isLoading {
					ProgressView("Loading…")
				} else if stores.isEmpty {
					Text("No stores found")
						.foregroundStyle(.secondary)
				} else {
					ForEach(stores) { store in
						Button {
							selectedStoreId = Int(store.id)
							selectedStoreName = storeDisplayName(store)
							dismiss()
						} label: {
							HStack {
								VStack(alignment: .leading, spacing: 2) {
									Text(store.name)
									Text(locationLine(store))
										.font(.footnote)
										.foregroundStyle(.secondary)
								}
								Spacer()
								if let mi = store.distanceMi {
									Text("\(mi, format: .number.precision(.fractionLength(1))) mi")
										.font(.footnote)
										.foregroundStyle(.secondary)
										.monospacedDigit()
								}
								if selectedStoreId == Int(store.id) {
									Image(systemName: "checkmark")
										.foregroundStyle(.tint)
								}
							}
						}
					}
				}
			}
		}
		.navigationTitle("Select Store")
		.toolbar {
			Button("Refresh") { Task { await refresh() } }
		}
		.task { await refresh() }
	}

	@ViewBuilder
	private var nearbySection: some View {
		Section("Nearby") {
			switch locationManager.authorizationStatus {
			case .notDetermined:
				Button("Enable Location") {
					locationManager.requestWhenInUseAuthorization()
				}
			case .restricted, .denied:
				Text("Location is disabled. You can still search by city/state.")
					.foregroundStyle(.secondary)
			default:
				if let loc = locationManager.lastLocation {
					Text("Using location: \(loc.coordinate.latitude, format: .number.precision(.fractionLength(4))), \(loc.coordinate.longitude, format: .number.precision(.fractionLength(4)))")
						.font(.footnote)
						.foregroundStyle(.secondary)
				} else {
					Text("Waiting for location…")
						.foregroundStyle(.secondary)
						.onAppear { locationManager.startUpdatingLocation() }
				}
			}
		}
	}

	@ViewBuilder
	private var citySection: some View {
		Section("City/State") {
			TextField("City (e.g. New York)", text: $city)
				.textInputAutocapitalization(.words)
				.autocorrectionDisabled()
			TextField("State (e.g. NY)", text: $state)
				.textInputAutocapitalization(.characters)
				.autocorrectionDisabled()
			Button("Search") { Task { await refresh() } }
		}
	}

	@MainActor
	private func refresh() async {
		errorMessage = nil
		isLoading = true
		defer { isLoading = false }

		do {
			let client = try APIClient(baseURLString: apiBaseURL)
			switch mode {
			case .nearby:
				let loc = locationManager.lastLocation
				stores = try await client.listStores(
					lat: loc?.coordinate.latitude,
					lng: loc?.coordinate.longitude,
					radiusMi: 25,
					limit: 100
				)
			case .city:
				stores = try await client.listStores(city: city, state: state, limit: 100)
			}
		} catch {
			// Fallback to mock data when API is unavailable
			stores = MockData.stores
			errorMessage = nil // Clear error, we have demo data
		}
	}

	private func storeDisplayName(_ store: StoreResponse) -> String {
		let loc = locationLine(store)
		if loc.isEmpty { return store.name }
		return "\(store.name) (\(loc))"
	}

	private func locationLine(_ store: StoreResponse) -> String {
		let parts = [store.city, store.state].compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
			.filter { !$0.isEmpty }
		return parts.joined(separator: ", ")
	}
}

#Preview {
	NavigationStack {
		StorePickerView(
			apiBaseURL: "http://localhost:8080",
			locationManager: LocationManager(),
			selectedStoreId: .constant(0),
			selectedStoreName: .constant("")
		)
	}
}
