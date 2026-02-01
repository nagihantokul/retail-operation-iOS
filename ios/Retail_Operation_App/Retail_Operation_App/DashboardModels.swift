import Foundation

struct DashboardResponse: Codable {
    let totalProducts: Int64
    let totalStores: Int64
    let lowStockCount: Int64
    let outOfStockCount: Int64
    let todayMovements: Int64
    let topProducts: [TopProductResponse]
    let recentMovements: [RecentMovementResponse]
}

struct TopProductResponse: Codable, Identifiable {
    let productId: Int64
    let productName: String
    let productSku: String
    let totalMovements: Int64

    var id: Int64 { productId }
}

struct RecentMovementResponse: Codable, Identifiable {
    let id: Int64
    let productId: Int64
    let productName: String
    let storeId: Int64
    let storeName: String
    let delta: Int64
    let reason: String?
    let createdAt: String

    var isPositive: Bool { delta > 0 }
    var formattedDelta: String {
        delta > 0 ? "+\(delta)" : "\(delta)"
    }
}
