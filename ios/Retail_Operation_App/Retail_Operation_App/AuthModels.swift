import Foundation

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct RegisterRequest: Codable {
    let email: String
    let password: String
    let firstName: String?
    let lastName: String?
    let storeId: Int64?
}

struct LoginResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let expiresInSeconds: Int64
    let user: UserResponse
}

struct UserResponse: Codable, Identifiable {
    let id: Int64
    let email: String
    let firstName: String?
    let lastName: String?
    let role: String
    let storeId: Int64?
    let storeName: String?
    let active: Bool
    let createdAt: String

    var displayName: String {
        if let first = firstName, let last = lastName {
            return "\(first) \(last)"
        } else if let first = firstName {
            return first
        } else {
            return email
        }
    }
}

struct RefreshTokenRequest: Codable {
    let refreshToken: String
}

struct ChangePasswordRequest: Codable {
    let currentPassword: String
    let newPassword: String
}
