import Combine
import Foundation

@MainActor
final class CustomerStore: ObservableObject {
    @Published private(set) var customers: [Customer] = []

    private let storageKey = "customers.v1"

    init() {
        load()
        if customers.isEmpty {
            customers = MockData.customers
            save()
        }
    }

    func customer(id: UUID) -> Customer? {
        customers.first { $0.id == id }
    }

    func updateNotes(customerId: UUID, notes: String) {
        guard let index = customers.firstIndex(where: { $0.id == customerId }) else { return }
        customers[index].notes = notes
        customers[index].updatedAt = Date()
        save()
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        do {
            customers = try Self.decoder.decode([Customer].self, from: data)
        } catch {
            customers = []
        }
    }

    private func save() {
        do {
            let data = try Self.encoder.encode(customers)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            // Ignore persistence errors in demo mode.
        }
    }

    private static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }()

    private static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
}

