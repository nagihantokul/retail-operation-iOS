import Foundation

struct ApiErrorResponse: Codable {
	let message: String
	let timestamp: String
}

struct ProductResponse: Codable, Identifiable {
	let id: Int64
	let sku: String
	let name: String
	let barcode: String?
	let category: String?
	let price: Double?
	let createdAt: String
	let updatedAt: String
}

struct StoreResponse: Codable, Identifiable {
	let id: Int64
	let code: String
	let name: String
	let address: String?
	let city: String?
	let state: String?
	let postalCode: String?
	let country: String?
	let latitude: Double?
	let longitude: Double?
	let createdAt: String
	let updatedAt: String
	let distanceKm: Double?
	let distanceMi: Double?
}

struct StoreAvailabilityResponse: Codable, Identifiable {
	var id: Int64 { storeId }

	let storeId: Int64
	let code: String
	let name: String
	let city: String?
	let state: String?
	let distanceKm: Double?
	let distanceMi: Double?
	let quantity: Int64
	let current: Bool
}

struct ProductAvailabilityResponse: Codable {
	let product: ProductResponse
	let stores: [StoreAvailabilityResponse]
}

struct InventoryStatusResponse: Codable {
	let storeId: Int64
	let productId: Int64
	let quantity: Int64
}

struct ActivityFeedItem: Identifiable, Decodable {
	let id: Int64
	let productId: Int64
	let productName: String
	let productSku: String
	let productImageUrl: String?
	let delta: Int
	let reason: String?
	let createdAt: String
}

// MARK: - Transfer Request (Endless Aisle)

struct TransferRequestResponse: Identifiable, Decodable {
	let id: Int64
	let fromStoreId: Int64
	let fromStoreName: String
	let toStoreId: Int64
	let toStoreName: String
	let productId: Int64
	let productName: String
	let productSku: String
	let productImageUrl: String?
	let quantity: Int
	let status: String
	let notes: String?
	let createdAt: String
}

// MARK: - BOPIS Order

struct BopisOrderResponse: Identifiable, Decodable {
	let id: Int64
	let orderNumber: String
	let storeId: Int64
	let customerName: String
	let customerEmail: String?
	let customerPhone: String?
	let status: String
	let notes: String?
	let items: [BopisOrderItemResponse]
	let totalItems: Int
	let createdAt: String
	let readyAt: String?
	let pickedUpAt: String?
}

struct BopisOrderItemResponse: Identifiable, Decodable {
	let id: Int64
	let productId: Int64
	let productName: String
	let productSku: String
	let productImageUrl: String?
	let quantity: Int
	let pickedQuantity: Int
}

