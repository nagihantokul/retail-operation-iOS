import SwiftUI

struct ContentView: View {
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome = false
    @AppStorage("apiBaseURL") private var apiBaseURL = "http://localhost:8080"
    @AppStorage("currentStoreId") private var currentStoreId = 0
    @AppStorage("currentStoreName") private var currentStoreName = ""
    @AppStorage("radiusMi") private var radiusMi = 10.0

    @StateObject private var locationManager = LocationManager()
    @ObservedObject private var authManager = AuthManager.shared

    var body: some View {
        if !hasSeenWelcome {
            WelcomeView {
                withAnimation {
                    hasSeenWelcome = true
                }
            }
        } else if authManager.isAuthenticated {
            mainTabView
        } else {
            LoginView(authManager: authManager)
        }
    }

    private var mainTabView: some View {
        TabView {
            HomeView(
                apiBaseURL: apiBaseURL,
                currentStoreId: $currentStoreId,
                currentStoreName: $currentStoreName,
                locationManager: locationManager
            )
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }

            NavigationStack {
                ScanView(
                    apiBaseURL: apiBaseURL,
                    currentStoreId: currentStoreId,
                    currentStoreName: currentStoreName,
                    radiusMi: radiusMi,
                    locationManager: locationManager
                )
            }
            .tabItem {
                Label("Scan", systemImage: "barcode.viewfinder")
            }

            NavigationStack {
                SettingsView(
                    apiBaseURL: $apiBaseURL,
                    currentStoreId: $currentStoreId,
                    currentStoreName: $currentStoreName,
                    radiusMi: $radiusMi
                )
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape")
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(CustomerStore())
        .environmentObject(SalesStore())
}
