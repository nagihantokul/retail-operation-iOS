import Foundation

struct Customer: Identifiable, Codable, Hashable {
    let id: UUID
    var firstName: String
    var lastName: String
    var email: String?
    var phone: String?
    var notes: String
    var preferredCategories: [String]
    var createdAt: Date
    var updatedAt: Date

    var displayName: String {
        let full = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespacesAndNewlines)
        return full.isEmpty ? "Customer" : full
    }

    var initials: String {
        let first = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        let last = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        let parts = [first, last].filter { !$0.isEmpty }
        let letters = parts.compactMap { $0.first }.prefix(2)
        let value = String(letters).uppercased()
        return value.isEmpty ? "C" : value
    }
}

