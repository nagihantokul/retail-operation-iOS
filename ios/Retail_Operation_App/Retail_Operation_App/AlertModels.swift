import Foundation

struct AlertResponse: Codable, Identifiable {
    let id: Int64
    let storeId: Int64
    let storeName: String
    let productId: Int64
    let productName: String
    let alertType: String
    let currentQuantity: Int
    let thresholdValue: Int
    let status: String
    let acknowledgedAt: String?
    let resolvedAt: String?
    let createdAt: String

    var isActive: Bool { status == "ACTIVE" }
    var isLowStock: Bool { alertType == "LOW_STOCK" }
    var isOutOfStock: Bool { alertType == "OUT_OF_STOCK" }

    var alertTypeDisplay: String {
        switch alertType {
        case "LOW_STOCK": return "Low Stock"
        case "OUT_OF_STOCK": return "Out of Stock"
        case "OVERSTOCK": return "Overstock"
        default: return alertType
        }
    }

    var alertColor: String {
        switch alertType {
        case "OUT_OF_STOCK": return "red"
        case "LOW_STOCK": return "orange"
        case "OVERSTOCK": return "purple"
        default: return "gray"
        }
    }
}
