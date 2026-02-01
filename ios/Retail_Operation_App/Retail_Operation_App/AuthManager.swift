import Combine
import Foundation
import SwiftUI

@MainActor
final class AuthManager: ObservableObject {
    static let shared = AuthManager()

    @Published var isAuthenticated = false
    @Published var currentUser: UserResponse?
    @Published var isLoading = false
    @Published var error: String?

    @AppStorage("apiBaseURL") private var apiBaseURL = "http://localhost:8080"
    @AppStorage("currentStoreId") private var currentStoreId = 0
    @AppStorage("currentStoreName") private var currentStoreName = ""

    private let keychain = KeychainHelper.shared

    private init() {
        checkAuthStatus()
    }

    var accessToken: String? {
        keychain.readString(forKey: "accessToken")
    }

    func checkAuthStatus() {
        if let token = accessToken, !token.isEmpty {
            isAuthenticated = true
            Task {
                await fetchCurrentUser()
            }
        } else {
            isAuthenticated = false
            currentUser = nil
        }
    }

    func login(email: String, password: String) async {
        isLoading = true
        error = nil

        do {
            let request = LoginRequest(email: email, password: password)
            let response: LoginResponse = try await post(path: "/api/v1/auth/login", body: request)

            saveTokens(response)
            currentUser = response.user
            isAuthenticated = true
        } catch let apiError as APIError {
            error = apiError.localizedDescription
        } catch {
            self.error = error.localizedDescription
        }

        isLoading = false
    }

    func register(email: String, password: String, firstName: String?, lastName: String?, storeId: Int64?) async {
        isLoading = true
        error = nil

        do {
            let request = RegisterRequest(
                email: email,
                password: password,
                firstName: firstName?.isEmpty == true ? nil : firstName,
                lastName: lastName?.isEmpty == true ? nil : lastName,
                storeId: storeId
            )
            let response: LoginResponse = try await post(path: "/api/v1/auth/register", body: request)

            saveTokens(response)
            currentUser = response.user
            isAuthenticated = true
        } catch let apiError as APIError {
            error = apiError.localizedDescription
        } catch {
            self.error = error.localizedDescription
        }

        isLoading = false
    }

    func loginAsDemo() {
        // Demo mode - skip backend authentication
        keychain.save("demo_token", forKey: "accessToken")
        keychain.save("demo_refresh", forKey: "refreshToken")
        keychain.save("0", forKey: "userId")

        currentUser = UserResponse(
            id: 0,
            email: "demo@store.com",
            firstName: "Demo",
            lastName: "User",
            role: "EMPLOYEE",
            storeId: 1,
            storeName: "Union Square",
            active: true,
            createdAt: ""
        )

        if currentStoreId == 0 {
            currentStoreId = 1
            currentStoreName = "Union Square"
        }

        isAuthenticated = true
        error = nil
    }

    func logout() {
        Task {
            if accessToken != nil && accessToken != "demo_token" {
                do {
                    try await postNoResponse(path: "/api/v1/auth/logout")
                } catch {
                    // Ignore logout errors
                }
            }

            await MainActor.run {
                keychain.clearAll()
                currentStoreId = 0
                currentStoreName = ""
                isAuthenticated = false
                currentUser = nil
            }
        }
    }

    func refreshToken() async -> Bool {
        guard let refreshToken = keychain.readString(forKey: "refreshToken") else {
            return false
        }

        do {
            let request = RefreshTokenRequest(refreshToken: refreshToken)
            let response: LoginResponse = try await post(path: "/api/v1/auth/refresh", body: request)
            saveTokens(response)
            currentUser = response.user
            return true
        } catch {
            logout()
            return false
        }
    }

    private func fetchCurrentUser() async {
        do {
            let user: UserResponse = try await get(path: "/api/v1/auth/me")
            currentUser = user
        } catch {
            // Token might be expired, try refresh
            let success = await refreshToken()
            if !success {
                logout()
            }
        }
    }

    private func saveTokens(_ response: LoginResponse) {
        keychain.save(response.accessToken, forKey: "accessToken")
        keychain.save(response.refreshToken, forKey: "refreshToken")
        keychain.save(String(response.user.id), forKey: "userId")

        if currentStoreId == 0, let storeId = response.user.storeId {
            currentStoreId = Int(storeId)
            currentStoreName = response.user.storeName ?? ""
        }
    }

    // MARK: - HTTP Methods

    private func get<T: Decodable>(path: String) async throws -> T {
        guard let url = URL(string: apiBaseURL + path) else {
            throw APIError.invalidBaseURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        addAuthHeader(&request)

        let (data, response) = try await URLSession.shared.data(for: request)
        try validateResponse(response, data: data)

        return try JSONDecoder().decode(T.self, from: data)
    }

    private func post<T: Decodable, B: Encodable>(path: String, body: B) async throws -> T {
        guard let url = URL(string: apiBaseURL + path) else {
            throw APIError.invalidBaseURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)
        addAuthHeader(&request)

        let (data, response) = try await URLSession.shared.data(for: request)
        try validateResponse(response, data: data)

        return try JSONDecoder().decode(T.self, from: data)
    }

    private func postNoResponse(path: String) async throws {
        guard let url = URL(string: apiBaseURL + path) else {
            throw APIError.invalidBaseURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        addAuthHeader(&request)

        let (data, response) = try await URLSession.shared.data(for: request)
        try validateResponse(response, data: data)
    }

    private func addAuthHeader(_ request: inout URLRequest) {
        if let token = accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
    }

    private func validateResponse(_ response: URLResponse, data: Data) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            if let errorResponse = try? JSONDecoder().decode(ApiErrorResponse.self, from: data) {
                throw APIError.httpError(statusCode: httpResponse.statusCode, message: errorResponse.message)
            }
            throw APIError.httpError(statusCode: httpResponse.statusCode, message: "Request failed")
        }
    }
}
