import SwiftUI

struct AlertsListView: View {
    @AppStorage("apiBaseURL") private var apiBaseURL = "http://localhost:8080"
    @AppStorage("currentStoreId") private var currentStoreId = 0

    @State private var alerts: [AlertResponse] = []
    @State private var isLoading = false
    @State private var error: String?

    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading alerts...")
            } else if let error = error {
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundColor(Color(red: 0.88, green: 0.82, blue: 0.72))
                    Text(error)
                        .foregroundColor(.secondary)
                    Button("Retry") {
                        Task { await loadAlerts() }
                    }
                }
            } else if alerts.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "checkmark.circle")
                        .font(.system(size: 60))
                        .foregroundColor(Color(red: 0.65, green: 0.78, blue: 0.68))
                    Text("No Active Alerts")
                        .font(.title2)
                        .fontWeight(.medium)
                    Text("All inventory levels are healthy")
                        .foregroundColor(.secondary)
                }
            } else {
                List(alerts) { alert in
                    AlertRow(alert: alert) {
                        Task { await acknowledgeAlert(alert.id) }
                    }
                }
            }
        }
        .navigationTitle("Alerts")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { Task { await loadAlerts() } }) {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
        .refreshable {
            await loadAlerts()
        }
        .task {
            await loadAlerts()
        }
    }

    private func loadAlerts() async {
        isLoading = true
        error = nil

        do {
            var path = "/api/v1/alerts?status=ACTIVE"
            if currentStoreId > 0 {
                path += "&storeId=\(currentStoreId)"
            }

            guard let url = URL(string: apiBaseURL + path) else {
                throw APIError.invalidBaseURL
            }

            var request = URLRequest(url: url)
            if let token = KeychainHelper.shared.readString(forKey: "accessToken") {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }

            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw APIError.invalidResponse
            }

            alerts = try JSONDecoder().decode([AlertResponse].self, from: data)
        } catch {
            // Fallback to mock data when API is unavailable
            if currentStoreId > 0 {
                alerts = MockData.alerts.filter { $0.storeId == Int64(currentStoreId) }
            } else {
                alerts = MockData.alerts
            }
        }

        isLoading = false
    }

    private func acknowledgeAlert(_ id: Int64) async {
        do {
            guard let url = URL(string: apiBaseURL + "/api/v1/alerts/\(id)/acknowledge") else {
                // Just remove from local list for demo
                alerts.removeAll { $0.id == id }
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            if let token = KeychainHelper.shared.readString(forKey: "accessToken") {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }

            let (_, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                // Remove from local list anyway for demo
                alerts.removeAll { $0.id == id }
                return
            }

            // Remove from list
            alerts.removeAll { $0.id == id }
        } catch {
            // Remove from local list for demo mode
            alerts.removeAll { $0.id == id }
        }
    }
}

struct AlertRow: View {
    let alert: AlertResponse
    let onAcknowledge: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: alertIcon)
                    .foregroundColor(alertColor)

                Text(alert.alertTypeDisplay)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(alertColor)

                Spacer()

                Text(alert.storeName)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Text(alert.productName)
                .font(.headline)

            HStack {
                Text("Current: \(alert.currentQuantity)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text("•")
                    .foregroundColor(.secondary)

                Text("Threshold: \(alert.thresholdValue)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Button("Acknowledge") {
                onAcknowledge()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
        }
        .padding(.vertical, 4)
    }

    private var alertIcon: String {
        switch alert.alertType {
        case "OUT_OF_STOCK": return "xmark.circle.fill"
        case "LOW_STOCK": return "exclamationmark.triangle.fill"
        case "OVERSTOCK": return "arrow.up.circle.fill"
        default: return "bell.fill"
        }
    }

    private var alertColor: Color {
        switch alert.alertType {
        case "OUT_OF_STOCK": return Color(red: 0.90, green: 0.65, blue: 0.60)
        case "LOW_STOCK": return Color(red: 0.88, green: 0.82, blue: 0.72)
        case "OVERSTOCK": return Color(red: 0.75, green: 0.72, blue: 0.82)
        default: return .gray
        }
    }
}

#Preview {
    NavigationStack {
        AlertsListView()
    }
}
