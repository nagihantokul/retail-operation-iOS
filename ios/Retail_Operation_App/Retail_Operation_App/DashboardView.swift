import SwiftUI

struct DashboardView: View {
    @AppStorage("apiBaseURL") private var apiBaseURL = "http://localhost:8080"
    @AppStorage("currentStoreId") private var currentStoreId = 0

    @State private var dashboard: DashboardResponse?
    @State private var isLoading = false
    @State private var error: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if isLoading {
                    ProgressView("Loading...")
                        .padding(.top, 50)
                } else if let error = error {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text(error)
                            .foregroundColor(.secondary)
                        Button("Retry") {
                            Task { await loadDashboard() }
                        }
                    }
                    .padding(.top, 50)
                } else if let dashboard = dashboard {
                    // KPI Cards
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        KPICard(title: "Products", value: "\(dashboard.totalProducts)", icon: "shippingbox", color: .blue)
                        KPICard(title: "Stores", value: "\(dashboard.totalStores)", icon: "building.2", color: .green)
                        KPICard(title: "Low Stock", value: "\(dashboard.lowStockCount)", icon: "exclamationmark.triangle", color: .orange)
                        KPICard(title: "Out of Stock", value: "\(dashboard.outOfStockCount)", icon: "xmark.circle", color: .red)
                    }
                    .padding(.horizontal)

                    // Today's Activity
                    HStack {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .foregroundColor(.purple)
                        Text("Today's Movements")
                            .font(.headline)
                        Spacer()
                        Text("\(dashboard.todayMovements)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.purple)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)

                    // Recent Movements
                    if !dashboard.recentMovements.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Recent Movements")
                                .font(.headline)
                                .padding(.horizontal)

                            ForEach(dashboard.recentMovements) { movement in
                                MovementRow(movement: movement)
                            }
                        }
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Dashboard")
        .refreshable {
            await loadDashboard()
        }
        .task {
            await loadDashboard()
        }
    }

    private func loadDashboard() async {
        isLoading = true
        error = nil

        do {
            var path = "/api/v1/dashboard"
            if currentStoreId > 0 {
                path = "/api/v1/dashboard/store/\(currentStoreId)"
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

            dashboard = try JSONDecoder().decode(DashboardResponse.self, from: data)
        } catch {
            self.error = error.localizedDescription
        }

        isLoading = false
    }
}

struct KPICard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(color)

            Text(value)
                .font(.title)
                .fontWeight(.bold)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct MovementRow: View {
    let movement: RecentMovementResponse

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(movement.productName)
                    .font(.subheadline)
                    .fontWeight(.medium)

                Text(movement.storeName)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text(movement.formattedDelta)
                .font(.headline)
                .foregroundColor(movement.isPositive ? .green : .red)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

#Preview {
    NavigationStack {
        DashboardView()
    }
}
