import SwiftUI

struct SettingsView: View {
    @Binding var apiBaseURL: String
    @Binding var currentStoreId: Int
    @Binding var currentStoreName: String
    @Binding var radiusMi: Double

    @ObservedObject private var authManager = AuthManager.shared

    var body: some View {
        Form {
            Section("Account") {
                if let user = authManager.currentUser {
                    LabeledContent("User", value: user.displayName)
                    LabeledContent("Email", value: user.email)
                    LabeledContent("Role", value: user.role)
                    if let storeName = user.storeName, !storeName.isEmpty {
                        LabeledContent("Home Store", value: storeName)
                    }
                } else {
                    Text("Not logged in")
                        .foregroundStyle(.secondary)
                }

                Button("Log Out", role: .destructive) {
                    authManager.logout()
                }
            }

            Section("Current Store") {
                if currentStoreId == 0 {
                    Text("No store selected")
                        .foregroundStyle(.secondary)
                } else {
                    LabeledContent("Store", value: currentStoreName.isEmpty ? "#\(currentStoreId)" : currentStoreName)
                }

                Button("Clear Store Selection", role: .destructive) {
                    currentStoreId = 0
                    currentStoreName = ""
                }
                .disabled(currentStoreId == 0)
            }

            Section("Nearby Search") {
                HStack {
                    Text("Radius (miles)")
                    Spacer()
                    Text(radiusMi, format: .number.precision(.fractionLength(1)))
                        .monospacedDigit()
                        .foregroundStyle(.secondary)
                }
                Slider(value: $radiusMi, in: 1...50, step: 1)
            }

            Section("About") {
                LabeledContent("App", value: "RetailOps")
                LabeledContent("Version", value: "1.0.0")
                LabeledContent("Build", value: "2026.1")
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView(
            apiBaseURL: .constant("http://localhost:8080"),
            currentStoreId: .constant(1),
            currentStoreName: .constant("Store NYC"),
            radiusMi: .constant(10)
        )
    }
}
