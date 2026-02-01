import Foundation

enum PaymentMethod: String, CaseIterable, Identifiable, Codable {
    case card = "Card"
    case applePay = "Apple Pay"
    case cash = "Cash"

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .card: return "creditcard"
        case .applePay: return "apple.logo"
        case .cash: return "banknote"
        }
    }
}

struct SaleLineItem: Identifiable, Codable, Hashable {
    let id: UUID
    let productId: Int64
    let sku: String
    let name: String
    let imageUrl: String?
    let quantity: Int
    let unitPriceCents: Int

    init(id: UUID = UUID(), productId: Int64, sku: String, name: String, imageUrl: String?, quantity: Int, unitPriceCents: Int) {
        self.id = id
        self.productId = productId
        self.sku = sku
        self.name = name
        self.imageUrl = imageUrl
        self.quantity = quantity
        self.unitPriceCents = unitPriceCents
    }

    var lineTotalCents: Int {
        unitPriceCents * quantity
    }
}

struct SaleReceipt: Identifiable, Codable, Hashable {
    let id: UUID
    let createdAt: Date
    let storeId: Int
    let storeName: String
    let customerId: UUID?
    let customerName: String?
    let paymentMethod: PaymentMethod
    let subtotalCents: Int
    let taxCents: Int
    let totalCents: Int
    let items: [SaleLineItem]

    var formattedSubtotal: String { Money.formatUSD(cents: subtotalCents) }
    var formattedTax: String { Money.formatUSD(cents: taxCents) }
    var formattedTotal: String { Money.formatUSD(cents: totalCents) }
}

enum Money {
    static func cents(from amount: Double) -> Int {
        Int((amount * 100.0).rounded())
    }

    static func formatUSD(cents: Int) -> String {
        let amount = Decimal(cents) / 100
        let number = amount as NSDecimalNumber
        return currencyFormatter.string(from: number) ?? "$0.00"
    }

    private static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter
    }()
}

