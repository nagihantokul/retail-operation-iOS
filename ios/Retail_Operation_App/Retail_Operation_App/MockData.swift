import Foundation

// MARK: - Mock Data for Demo Mode

struct MockData {

    // MARK: - Stores

    static let stores: [StoreResponse] = [
        StoreResponse(id: 1, code: "SF-UNION", name: "Union Square", address: "170 O'Farrell St", city: "San Francisco", state: "CA", postalCode: "94102", country: "US", latitude: 37.7867, longitude: -122.4069, createdAt: "2024-01-01", updatedAt: "2024-01-01", distanceKm: nil, distanceMi: nil),
        StoreResponse(id: 2, code: "SF-MARKET", name: "Market Street", address: "865 Market St", city: "San Francisco", state: "CA", postalCode: "94103", country: "US", latitude: 37.7841, longitude: -122.4064, createdAt: "2024-01-01", updatedAt: "2024-01-01", distanceKm: nil, distanceMi: nil),
        StoreResponse(id: 3, code: "SF-MISSION", name: "Mission District", address: "2300 Mission St", city: "San Francisco", state: "CA", postalCode: "94110", country: "US", latitude: 37.7599, longitude: -122.4183, createdAt: "2024-01-01", updatedAt: "2024-01-01", distanceKm: nil, distanceMi: nil),
        StoreResponse(id: 4, code: "OAK-BROADWAY", name: "Oakland Broadway", address: "1955 Broadway", city: "Oakland", state: "CA", postalCode: "94612", country: "US", latitude: 37.8085, longitude: -122.2711, createdAt: "2024-01-01", updatedAt: "2024-01-01", distanceKm: nil, distanceMi: nil),
        StoreResponse(id: 5, code: "SJ-VALLEY", name: "Valley Fair", address: "2855 Stevens Creek Blvd", city: "San Jose", state: "CA", postalCode: "95050", country: "US", latitude: 37.3249, longitude: -121.9470, createdAt: "2024-01-01", updatedAt: "2024-01-01", distanceKm: nil, distanceMi: nil),
    ]

    // MARK: - Products

    static let products: [ProductSearchResult] = [
        ProductSearchResult(id: 1, sku: "BLZ-WOL-BLK", name: "Wool Blend Blazer - Black", barcode: "8901234567890", category: "Blazers", price: 149.00, imageUrl: "https://static.zara.net/photos///2024/V/0/1/p/0706/300/800/2/w/563/0706300800_1_1_1.jpg", quantity: 25),
        ProductSearchResult(id: 2, sku: "JNS-SLM-BLU", name: "Slim Fit Jeans - Indigo", barcode: "8901234567891", category: "Jeans", price: 59.90, imageUrl: "https://static.zara.net/photos///2024/V/0/1/p/4391/300/251/2/w/563/4391300251_1_1_1.jpg", quantity: 42),
        ProductSearchResult(id: 3, sku: "TSH-CTN-WHT", name: "Cotton T-Shirt - White", barcode: "8901234567892", category: "T-Shirts", price: 19.90, imageUrl: "https://static.zara.net/photos///2024/V/0/1/p/3067/350/800/2/w/563/3067350800_1_1_1.jpg", quantity: 85),
        ProductSearchResult(id: 4, sku: "DRS-SLK-RED", name: "Silk Midi Dress - Red", barcode: "8901234567893", category: "Dresses", price: 129.00, imageUrl: "https://static.zara.net/photos///2024/V/0/1/p/1255/828/800/2/w/563/1255828800_1_1_1.jpg", quantity: 12),
        ProductSearchResult(id: 5, sku: "JKT-LTH-BRN", name: "Leather Jacket - Brown", barcode: "8901234567894", category: "Jackets", price: 299.00, imageUrl: "https://static.zara.net/photos///2024/V/0/1/p/6318/310/800/2/w/563/6318310800_1_1_1.jpg", quantity: 8),
        ProductSearchResult(id: 6, sku: "SWT-CSH-GRY", name: "Cashmere Sweater - Grey", barcode: "8901234567895", category: "Sweaters", price: 89.90, imageUrl: "https://static.zara.net/photos///2024/V/0/1/p/0706/050/712/2/w/563/0706050712_1_1_1.jpg", quantity: 35),
        ProductSearchResult(id: 7, sku: "PNT-CHN-KHK", name: "Chino Pants - Khaki", barcode: "8901234567896", category: "Pants", price: 49.90, imageUrl: "https://static.zara.net/photos///2024/V/0/1/p/5580/410/251/2/w/563/5580410251_1_1_1.jpg", quantity: 28),
        ProductSearchResult(id: 8, sku: "SKT-PLT-NVY", name: "Pleated Skirt - Navy", barcode: "8901234567897", category: "Skirts", price: 45.90, imageUrl: "https://static.zara.net/photos///2024/V/0/1/p/1165/300/800/2/w/563/1165300800_1_1_1.jpg", quantity: 18),
        ProductSearchResult(id: 9, sku: "COT-WNT-CML", name: "Winter Coat - Camel", barcode: "8901234567898", category: "Coats", price: 199.00, imageUrl: "https://static.zara.net/photos///2024/V/0/1/p/5536/478/250/2/w/563/5536478250_1_1_1.jpg", quantity: 5),
        ProductSearchResult(id: 10, sku: "SHT-LNN-PIN", name: "Linen Shirt - Pink", barcode: "8901234567899", category: "Shirts", price: 39.90, imageUrl: "https://static.zara.net/photos///2024/V/0/1/p/2298/300/040/2/w/563/2298300040_1_1_1.jpg", quantity: 45),
    ]

    // MARK: - Customers (Clienteling)

    static let customers: [Customer] = [
        Customer(
            id: UUID(uuidString: "9C5F75E1-7A3E-4FD8-A2B9-2A4BBA9F2C77")!,
            firstName: "Jane",
            lastName: "Doe",
            email: "jane.doe@email.com",
            phone: "415-555-0110",
            notes: "Prefers neutral colors. Usually buys size M.",
            preferredCategories: ["Dresses", "T-Shirts"],
            createdAt: Date(timeIntervalSince1970: 1_704_067_200),
            updatedAt: Date(timeIntervalSince1970: 1_704_067_200)
        ),
        Customer(
            id: UUID(uuidString: "38E7D92E-2A0B-4F61-A0E3-2A1C2C9C8B6E")!,
            firstName: "John",
            lastName: "Smith",
            email: "john.smith@email.com",
            phone: "415-555-0101",
            notes: "Likes denim fits; ask about inseam.",
            preferredCategories: ["Jeans", "Jackets"],
            createdAt: Date(timeIntervalSince1970: 1_704_153_600),
            updatedAt: Date(timeIntervalSince1970: 1_704_153_600)
        ),
        Customer(
            id: UUID(uuidString: "F7F1A7E3-3B33-4B97-8C0A-3B2C5A5D8D12")!,
            firstName: "Sarah",
            lastName: "Johnson",
            email: "sarah.j@email.com",
            phone: "415-555-0102",
            notes: "Gift shopper. Often asks for wrapping.",
            preferredCategories: ["Coats", "Sweaters"],
            createdAt: Date(timeIntervalSince1970: 1_704_240_000),
            updatedAt: Date(timeIntervalSince1970: 1_704_240_000)
        ),
        Customer(
            id: UUID(uuidString: "B4B25B72-7B20-4F4A-9C14-C15AA9F2C9C1")!,
            firstName: "Mike",
            lastName: "Davis",
            email: nil,
            phone: "415-555-0103",
            notes: "Prefers quick checkout. Usually pays with card.",
            preferredCategories: ["Shirts", "Pants"],
            createdAt: Date(timeIntervalSince1970: 1_704_326_400),
            updatedAt: Date(timeIntervalSince1970: 1_704_326_400)
        ),
        Customer(
            id: UUID(uuidString: "0E4E5B30-8E6D-4A63-B7C8-2C08A9E84C33")!,
            firstName: "Emily",
            lastName: "Chen",
            email: "emily.chen@email.com",
            phone: "415-555-0142",
            notes: "Interested in new arrivals; likes bold colors.",
            preferredCategories: ["Skirts", "Blazers"],
            createdAt: Date(timeIntervalSince1970: 1_704_412_800),
            updatedAt: Date(timeIntervalSince1970: 1_704_412_800)
        ),
    ]

    // MARK: - Store Availability

    static func storeAvailability(for productId: Int64, currentStoreId: Int) -> [StoreAvailabilityResponse] {
        let quantities: [Int64: [Int64]] = [
            1: [25, 15, 5, 18, 30, 22],
            2: [42, 22, 12, 35, 50, 28],
            3: [85, 55, 40, 60, 95, 70],
            4: [12, 8, 2, 10, 20, 15],
            5: [8, 3, 0, 12, 15, 10],
            6: [35, 20, 8, 25, 40, 30],
            7: [28, 18, 15, 20, 32, 25],
            8: [18, 12, 6, 14, 24, 16],
            9: [5, 6, 4, 9, 18, 12],
            10: [45, 30, 22, 38, 55, 42],
        ]

        let productQuantities = quantities[productId] ?? [10, 10, 10, 10, 10, 10]

        return stores.enumerated().map { index, store in
            StoreAvailabilityResponse(
                storeId: store.id,
                code: store.code,
                name: store.name,
                city: store.city,
                state: store.state,
                distanceKm: Double(index) * 2.5,
                distanceMi: Double(index) * 1.5,
                quantity: productQuantities[index],
                current: store.id == Int64(currentStoreId)
            )
        }
    }

    // MARK: - BOPIS Orders

    static let bopisOrders: [BopisOrderResponse] = [
        BopisOrderResponse(
            id: 1,
            orderNumber: "ORD-2024-001",
            storeId: 1,
            customerName: "John Smith",
            customerEmail: "john@email.com",
            customerPhone: "415-555-0101",
            status: "NEW",
            notes: nil,
            items: [
                BopisOrderItemResponse(id: 1, productId: 1, productName: "Wool Blend Blazer - Black", productSku: "BLZ-WOL-BLK", productImageUrl: products[0].imageUrl, quantity: 1, pickedQuantity: 0),
                BopisOrderItemResponse(id: 2, productId: 3, productName: "Cotton T-Shirt - White", productSku: "TSH-CTN-WHT", productImageUrl: products[2].imageUrl, quantity: 2, pickedQuantity: 0)
            ],
            totalItems: 3,
            createdAt: "2024-01-26T10:00:00Z",
            readyAt: nil,
            pickedUpAt: nil
        ),
        BopisOrderResponse(
            id: 2,
            orderNumber: "ORD-2024-002",
            storeId: 1,
            customerName: "Sarah Johnson",
            customerEmail: "sarah@email.com",
            customerPhone: "415-555-0102",
            status: "PREPARING",
            notes: nil,
            items: [
                BopisOrderItemResponse(id: 3, productId: 2, productName: "Slim Fit Jeans - Indigo", productSku: "JNS-SLM-BLU", productImageUrl: products[1].imageUrl, quantity: 1, pickedQuantity: 0),
                BopisOrderItemResponse(id: 4, productId: 5, productName: "Leather Jacket - Brown", productSku: "JKT-LTH-BRN", productImageUrl: products[4].imageUrl, quantity: 1, pickedQuantity: 0)
            ],
            totalItems: 2,
            createdAt: "2024-01-26T09:30:00Z",
            readyAt: nil,
            pickedUpAt: nil
        ),
        BopisOrderResponse(
            id: 3,
            orderNumber: "ORD-2024-003",
            storeId: 1,
            customerName: "Mike Davis",
            customerEmail: "mike@email.com",
            customerPhone: "415-555-0103",
            status: "READY",
            notes: nil,
            items: [
                BopisOrderItemResponse(id: 5, productId: 4, productName: "Silk Midi Dress - Red", productSku: "DRS-SLK-RED", productImageUrl: products[3].imageUrl, quantity: 1, pickedQuantity: 1)
            ],
            totalItems: 1,
            createdAt: "2024-01-26T08:00:00Z",
            readyAt: "2024-01-26T08:45:00Z",
            pickedUpAt: nil
        ),
    ]

    // MARK: - Search

    static func searchProducts(query: String) -> [ProductSearchResult] {
        if query.isEmpty {
            return products
        }
        let lowercased = query.lowercased()
        return products.filter {
            $0.name.lowercased().contains(lowercased) ||
            $0.sku.lowercased().contains(lowercased) ||
            $0.barcode?.contains(query) == true ||
            $0.category?.lowercased().contains(lowercased) == true
        }
    }

    // MARK: - Alerts (Low Stock)

    static let alerts: [AlertResponse] = [
        AlertResponse(
            id: 1,
            storeId: 1,
            storeName: "Union Square",
            productId: 9,
            productName: "Winter Coat - Camel",
            alertType: "LOW_STOCK",
            currentQuantity: 5,
            thresholdValue: 10,
            status: "ACTIVE",
            acknowledgedAt: nil,
            resolvedAt: nil,
            createdAt: "2024-01-26T08:00:00Z"
        ),
        AlertResponse(
            id: 2,
            storeId: 1,
            storeName: "Union Square",
            productId: 5,
            productName: "Leather Jacket - Brown",
            alertType: "LOW_STOCK",
            currentQuantity: 8,
            thresholdValue: 15,
            status: "ACTIVE",
            acknowledgedAt: nil,
            resolvedAt: nil,
            createdAt: "2024-01-26T09:30:00Z"
        ),
        AlertResponse(
            id: 3,
            storeId: 2,
            storeName: "Market Street",
            productId: 4,
            productName: "Silk Midi Dress - Red",
            alertType: "OUT_OF_STOCK",
            currentQuantity: 0,
            thresholdValue: 5,
            status: "ACTIVE",
            acknowledgedAt: nil,
            resolvedAt: nil,
            createdAt: "2024-01-26T07:15:00Z"
        ),
        AlertResponse(
            id: 4,
            storeId: 1,
            storeName: "Union Square",
            productId: 4,
            productName: "Silk Midi Dress - Red",
            alertType: "LOW_STOCK",
            currentQuantity: 12,
            thresholdValue: 15,
            status: "ACTIVE",
            acknowledgedAt: nil,
            resolvedAt: nil,
            createdAt: "2024-01-26T10:00:00Z"
        ),
        AlertResponse(
            id: 5,
            storeId: 3,
            storeName: "Mission District",
            productId: 5,
            productName: "Leather Jacket - Brown",
            alertType: "OUT_OF_STOCK",
            currentQuantity: 0,
            thresholdValue: 10,
            status: "ACTIVE",
            acknowledgedAt: nil,
            resolvedAt: nil,
            createdAt: "2024-01-26T06:45:00Z"
        ),
    ]
}
