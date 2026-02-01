import Foundation

enum APIError: LocalizedError {
	case invalidBaseURL
	case invalidResponse
	case httpError(statusCode: Int, message: String?)
	case decodingError(underlying: Error)

	var errorDescription: String? {
		switch self {
		case .invalidBaseURL:
			return "Invalid API base URL."
		case .invalidResponse:
			return "Invalid response from server."
		case let .httpError(statusCode, message):
			if let message, !message.isEmpty {
				return "\(statusCode): \(message)"
			}
			return "Request failed (\(statusCode))."
		case let .decodingError(underlying):
			return "Failed to decode server response: \(underlying.localizedDescription)"
		}
	}
}

struct APIClient: Sendable {
    let baseURL: URL
    private let keychain = KeychainHelper.shared

	init(baseURLString: String) throws {
		guard let url = URL(string: baseURLString.trimmingCharacters(in: .whitespacesAndNewlines)),
			  url.scheme != nil else {
			throw APIError.invalidBaseURL
		}
		self.baseURL = url
	}

	func listStores(
		lat: Double? = nil,
		lng: Double? = nil,
		radiusMi: Double? = nil,
		city: String? = nil,
		state: String? = nil,
		limit: Int? = nil
	) async throws -> [StoreResponse] {
		var items: [URLQueryItem] = []
		if let lat { items.append(.init(name: "lat", value: String(lat))) }
		if let lng { items.append(.init(name: "lng", value: String(lng))) }
		if let radiusMi { items.append(.init(name: "radiusMi", value: String(radiusMi))) }
		if let city, !city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
			items.append(.init(name: "city", value: city))
		}
		if let state, !state.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
			items.append(.init(name: "state", value: state))
		}
		if let limit { items.append(.init(name: "limit", value: String(limit))) }
		return try await get(path: "/api/v1/stores", queryItems: items)
	}

	func availabilityByBarcode(
		barcode: String,
		storeId: Int,
		lat: Double? = nil,
		lng: Double? = nil,
		radiusMi: Double? = nil,
		limit: Int? = nil
	) async throws -> ProductAvailabilityResponse {
		var items: [URLQueryItem] = [.init(name: "storeId", value: String(storeId))]
		if let lat { items.append(.init(name: "lat", value: String(lat))) }
		if let lng { items.append(.init(name: "lng", value: String(lng))) }
		if let radiusMi { items.append(.init(name: "radiusMi", value: String(radiusMi))) }
		if let limit { items.append(.init(name: "limit", value: String(limit))) }

		let safeBarcode = barcode.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? barcode
		return try await get(path: "/api/v1/products/by-barcode/\(safeBarcode)/availability", queryItems: items)
	}

    func searchProducts(query: String, storeId: Int) async throws -> [ProductSearchResult] {
        var items: [URLQueryItem] = [.init(name: "storeId", value: String(storeId))]
        if !query.isEmpty {
            items.append(.init(name: "q", value: query))
        }
        return try await get(path: "/api/v1/products/search", queryItems: items)
    }

    func getActivityFeed(storeId: Int, limit: Int = 20) async throws -> [ActivityFeedItem] {
        let items: [URLQueryItem] = [.init(name: "limit", value: String(limit))]
        return try await get(path: "/api/v1/inventory/activity/\(storeId)", queryItems: items)
    }

    func adjustInventory(storeId: Int, productId: Int, delta: Int, reason: String) async throws {
        struct AdjustRequest: Encodable {
            let storeId: Int
            let productId: Int
            let delta: Int
            let reason: String
        }
        let body = AdjustRequest(storeId: storeId, productId: productId, delta: delta, reason: reason)
        let _: InventoryStatusResponse = try await post(path: "/api/v1/inventory/adjust", body: body)
    }

    // MARK: - Transfer Requests (Endless Aisle)

    func createTransferRequest(fromStoreId: Int, toStoreId: Int, productId: Int, quantity: Int, notes: String?) async throws -> TransferRequestResponse {
        struct CreateRequest: Encodable {
            let fromStoreId: Int
            let toStoreId: Int
            let productId: Int
            let quantity: Int
            let notes: String?
        }
        let body = CreateRequest(fromStoreId: fromStoreId, toStoreId: toStoreId, productId: productId, quantity: quantity, notes: notes)
        return try await post(path: "/api/v1/transfer-requests", body: body)
    }

    func getIncomingTransfers(storeId: Int) async throws -> [TransferRequestResponse] {
        return try await get(path: "/api/v1/transfer-requests/incoming/\(storeId)")
    }

    // MARK: - BOPIS Orders

    func getBopisOrders(storeId: Int) async throws -> [BopisOrderResponse] {
        return try await get(path: "/api/v1/bopis/orders/\(storeId)")
    }

    func getActiveBopisOrders(storeId: Int) async throws -> [BopisOrderResponse] {
        return try await get(path: "/api/v1/bopis/orders/\(storeId)/active")
    }

    func markOrderPreparing(orderId: Int) async throws -> BopisOrderResponse {
        return try await postEmpty(path: "/api/v1/bopis/order/\(orderId)/preparing")
    }

    func markOrderReady(orderId: Int) async throws -> BopisOrderResponse {
        return try await postEmpty(path: "/api/v1/bopis/order/\(orderId)/ready")
    }

    func markOrderPickedUp(orderId: Int) async throws -> BopisOrderResponse {
        return try await postEmpty(path: "/api/v1/bopis/order/\(orderId)/picked-up")
    }

	// MARK: - Core

	private func get<T: Decodable>(path: String, queryItems: [URLQueryItem] = []) async throws -> T {
		var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
		components?.path = normalizedPath(path)
		if !queryItems.isEmpty {
			components?.queryItems = queryItems
		}
		guard let url = components?.url else { throw APIError.invalidBaseURL }

		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		request.setValue("application/json", forHTTPHeaderField: "Accept")
		addAuthHeader(&request)

		let (data, response) = try await URLSession.shared.data(for: request)
		guard let http = response as? HTTPURLResponse else { throw APIError.invalidResponse }
		guard (200..<300).contains(http.statusCode) else {
			throw APIError.httpError(statusCode: http.statusCode, message: decodeApiMessage(from: data))
		}

		do {
			return try JSONDecoder().decode(T.self, from: data)
		} catch {
			throw APIError.decodingError(underlying: error)
		}
	}

	private func post<T: Decodable, B: Encodable>(path: String, body: B) async throws -> T {
		var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
		components?.path = normalizedPath(path)
		guard let url = components?.url else { throw APIError.invalidBaseURL }

		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		request.setValue("application/json", forHTTPHeaderField: "Accept")
		request.httpBody = try JSONEncoder().encode(body)
		addAuthHeader(&request)

		let (data, response) = try await URLSession.shared.data(for: request)
		guard let http = response as? HTTPURLResponse else { throw APIError.invalidResponse }
		guard (200..<300).contains(http.statusCode) else {
			throw APIError.httpError(statusCode: http.statusCode, message: decodeApiMessage(from: data))
		}

		do {
			return try JSONDecoder().decode(T.self, from: data)
		} catch {
			throw APIError.decodingError(underlying: error)
		}
	}

	private func postEmpty<T: Decodable>(path: String) async throws -> T {
		var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
		components?.path = normalizedPath(path)
		guard let url = components?.url else { throw APIError.invalidBaseURL }

		var request = URLRequest(url: url)
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Accept")
		addAuthHeader(&request)

		let (data, response) = try await URLSession.shared.data(for: request)
		guard let http = response as? HTTPURLResponse else { throw APIError.invalidResponse }
		guard (200..<300).contains(http.statusCode) else {
			throw APIError.httpError(statusCode: http.statusCode, message: decodeApiMessage(from: data))
		}

		do {
			return try JSONDecoder().decode(T.self, from: data)
		} catch {
			throw APIError.decodingError(underlying: error)
		}
	}

	private func normalizedPath(_ path: String) -> String {
		if path.hasPrefix("/") { return path }
		return "/" + path
	}

	private func addAuthHeader(_ request: inout URLRequest) {
		if let token = keychain.readString(forKey: "accessToken"), !token.isEmpty {
			request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		}
	}

	private func decodeApiMessage(from data: Data) -> String? {
		guard let decoded = try? JSONDecoder().decode(ApiErrorResponse.self, from: data) else {
			return String(data: data, encoding: .utf8)
		}
		return decoded.message
	}
}
