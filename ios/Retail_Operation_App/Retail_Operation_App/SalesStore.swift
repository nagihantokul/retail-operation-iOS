import Combine
import Foundation

@MainActor
final class SalesStore: ObservableObject {
    @Published private(set) var receipts: [SaleReceipt] = []

    private let storageKey = "salesReceipts.v1"

    init() {
        load()
    }

    func add(_ receipt: SaleReceipt) {
        receipts.insert(receipt, at: 0)
        save()
    }

    func receipts(for customerId: UUID) -> [SaleReceipt] {
        receipts.filter { $0.customerId == customerId }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        do {
            receipts = try Self.decoder.decode([SaleReceipt].self, from: data)
        } catch {
            receipts = []
        }
    }

    private func save() {
        do {
            let data = try Self.encoder.encode(receipts)
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

