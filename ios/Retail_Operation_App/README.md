# RetailOps iOS Application

<div align="center">

![Platform](https://img.shields.io/badge/Platform-iOS%2016%2B-blue)
![Swift](https://img.shields.io/badge/Swift-5.9-orange)
![SwiftUI](https://img.shields.io/badge/UI-SwiftUI-purple)

**Native iOS app for retail sales associates**

</div>

---

## Overview

The RetailOps iOS app is a native SwiftUI application designed for retail sales associates. It provides instant access to inventory information, barcode scanning, checkout capabilities, and customer management—all from the sales floor.

---

## Features

| Feature | Description | Status |
|---------|-------------|--------|
| **Welcome Onboarding** | Swipeable feature introduction | ✅ Complete |
| **Authentication** | JWT-based login with Keychain storage | ✅ Complete |
| **Demo Mode** | Fully functional offline demo | ✅ Complete |
| **Store Selection** | Location-based store picker | ✅ Complete |
| **Barcode Scanner** | Camera-based scanning with Vision framework | ✅ Complete |
| **Product Search** | Search by name, SKU, or barcode | ✅ Complete |
| **Store Availability** | Cross-store inventory check | ✅ Complete |
| **Low Stock Alerts** | Configurable threshold alerts | ✅ Complete |
| **BOPIS Orders** | Buy Online, Pick Up In Store | ✅ Complete |
| **Mobile Checkout** | Cart and customer linking | ✅ Complete |
| **Clienteling** | Customer profiles and history | ✅ Complete |
| **AI Assistant** | Natural language product queries | ✅ Complete |
| **Stock Adjustments** | Record damages, returns | ✅ Complete |
| **Inventory Counts** | Cycle counting workflow | ✅ Complete |

---

## Requirements

- **iOS 16.0+**
- **Xcode 15.0+**
- **Swift 5.9+**

---

## Getting Started

### Quick Start (Demo Mode)

```bash
# Open project
open Retail_Operation_App.xcodeproj

# Select simulator (iPhone 14 or newer recommended)
# Press Cmd+R to build and run

# On launch:
# 1. Swipe through welcome screens
# 2. Tap "Get Started"
# 3. Tap "Demo Mode" to explore without backend
```

### Connect to Backend

1. Run the Spring Boot backend (see [backend README](../../backend/README.md))
2. In the app, go to **Settings**
3. Update **API URL** to your backend address (e.g., `http://localhost:8080`)
4. Login with backend credentials

---

## Architecture

### Project Structure

```
Retail_Operation_App/
├── Retail_Operation_AppApp.swift   # App entry point
├── ContentView.swift               # Root view with navigation
│
├── Views/
│   ├── WelcomeView.swift           # Onboarding carousel
│   ├── LoginView.swift             # Authentication
│   ├── HomeView.swift              # Dashboard & actions
│   ├── ScanView.swift              # Product lookup
│   ├── BarcodeScannerView.swift    # Camera scanner
│   ├── ProductDetailView.swift     # Product info
│   ├── CheckoutView.swift          # Cart & payment
│   ├── OrdersView.swift            # BOPIS orders
│   ├── CustomersView.swift         # Clienteling
│   ├── AlertsListView.swift        # Low stock alerts
│   ├── TransfersView.swift         # Stock transfers
│   ├── InventoryCountView.swift    # Cycle counting
│   ├── AIAssistantView.swift       # AI queries
│   └── SettingsView.swift          # App configuration
│
├── Models/
│   ├── Models.swift                # Core data models
│   ├── AuthModels.swift            # Auth request/response
│   ├── SalesModels.swift           # Checkout models
│   ├── CustomerModels.swift        # Customer data
│   ├── AlertModels.swift           # Alert models
│   └── DashboardModels.swift       # Dashboard data
│
├── State/
│   ├── AuthManager.swift           # Auth singleton
│   ├── CustomerStore.swift         # Customer state
│   ├── SalesStore.swift            # Cart state
│   └── LocationManager.swift       # Location services
│
├── Services/
│   ├── APIClient.swift             # Network layer
│   ├── KeychainHelper.swift        # Secure storage
│   └── MockData.swift              # Demo data
│
└── Assets.xcassets/                # Images & colors
```

### Design Patterns

| Pattern | Usage |
|---------|-------|
| **MVVM** | Views observe state from managers/stores |
| **Singleton** | AuthManager for global auth state |
| **Environment Objects** | CustomerStore, SalesStore injection |
| **async/await** | All network calls |
| **@AppStorage** | User preferences persistence |

---

## Key Components

### Authentication

```swift
// Login flow
await AuthManager.shared.login(email: email, password: password)

// Check auth state
if authManager.isAuthenticated {
    // Show main app
}

// Demo mode (no backend)
AuthManager.shared.loginAsDemo()
```

### API Client

```swift
// Initialize client
let client = try APIClient(baseURLString: "http://localhost:8080")

// Search products
let results = try await client.searchProducts(query: "blazer", storeId: 1)

// Get store availability
let stores = try await client.getStoreAvailability(
    productId: 123,
    currentStoreId: 1,
    latitude: 37.78,
    longitude: -122.41,
    radiusMi: 10
)
```

### Barcode Scanner

```swift
BarcodeScannerView { barcode in
    // Handle scanned barcode
    searchText = barcode
    await search()
} onError: { error in
    // Handle camera error
}
```

### Mock Data (Demo Mode)

When API fails, views automatically fall back to mock data:

```swift
do {
    results = try await client.searchProducts(query: query)
} catch {
    // Fallback to mock data
    results = MockData.searchProducts(query: query)
}
```

---

## UI Components

### Color Palette

The app uses a cohesive pastel color scheme:

```swift
Color.pastelSage      // Primary actions
Color.pastelMint      // Secondary
Color.pastelTeal      // Scanner, highlights
Color.pastelCoral     // Alerts, warnings
Color.pastelSand      // Orders
Color.pastelLavender  // Inventory
Color.pastelSlate     // Customers
```

### Reusable Components

| Component | Purpose |
|-----------|---------|
| `ActionCard` | Dashboard action buttons |
| `SmallActionCard` | Compact action items |
| `StatCard` | KPI display |
| `ProductRowView` | Product list item |
| `AlertRow` | Alert list item |
| `FeatureCard` | Onboarding carousel |

---

## Testing

### Manual Testing

1. **Demo Mode**: Test all features without backend
2. **Barcode Scanning**: Use printed barcodes or another device
3. **Location**: Simulator allows custom location setting

### Test Barcodes (Demo)

| Barcode | Product |
|---------|---------|
| 8901234567890 | Wool Blend Blazer - Black |
| 8901234567891 | Slim Fit Jeans - Indigo |
| 8901234567892 | Cotton T-Shirt - White |
| 8901234567893 | Silk Midi Dress - Red |
| 8901234567894 | Leather Jacket - Brown |

---

## Configuration

### App Settings

| Setting | Default | Description |
|---------|---------|-------------|
| API URL | http://localhost:8080 | Backend server address |
| Current Store | None | Selected store for operations |
| Search Radius | 10 miles | Nearby store radius |

### Info.plist Permissions

| Permission | Usage |
|------------|-------|
| Camera | Barcode scanning |
| Location When In Use | Nearby store finding |

---

## Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| "Could not connect to server" | Check API URL in Settings, ensure backend is running |
| Camera not working | Check camera permission in Settings app |
| Login fails | Verify credentials, check backend logs |
| Mock data not showing | API errors should auto-fallback; check console |

### Debug Tips

```swift
// Enable network logging
// In APIClient.swift, print request/response

// Check Keychain
print(KeychainHelper.shared.readString(forKey: "accessToken"))

// View UserDefaults
print(UserDefaults.standard.dictionaryRepresentation())
```

---

## Build & Deploy

### Debug Build

```bash
xcodebuild -project Retail_Operation_App.xcodeproj \
  -scheme Retail_Operation_App \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  build
```

### Release Build

```bash
xcodebuild -project Retail_Operation_App.xcodeproj \
  -scheme Retail_Operation_App \
  -configuration Release \
  -archivePath build/Retail_Operation_App.xcarchive \
  archive
```

---

## Future Enhancements

| Feature | Priority | Status |
|---------|----------|--------|
| Push Notifications | P0 | Planned |
| Offline Mode | P0 | Planned |
| Apple Pay Integration | P1 | Planned |
| Widget Support | P2 | Backlog |
| Watch App | P3 | Backlog |

---

<div align="center">

**Part of the RetailOps Suite**

[Main Documentation](../../README.md) • [Backend](../../backend/README.md) • [API Docs](../../api/)

</div>
