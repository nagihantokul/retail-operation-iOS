# RetailOps - Mobile Inventory Management for Sales Associates

<div align="center">

![Platform](https://img.shields.io/badge/Platform-iOS%2016%2B-blue)
![Backend](https://img.shields.io/badge/Backend-Spring%20Boot%203-green)
![Swift](https://img.shields.io/badge/Swift-5.9-orange)
![License](https://img.shields.io/badge/License-MIT-yellow)

**Empowering retail sales associates with real-time inventory visibility and seamless stock management.**

[Problem](#-problem-statement) • [Solution](#-solution) • [Features](#-features) • [Documentation](#-product-documentation) • [Demo](#-demo) • [Tech Stack](#-tech-stack)

---

### Quick Links

| Documentation | Description |
|---------------|-------------|
| [Product Requirements (PRD)](docs/PRD.md) | Complete product specification |
| [User Personas](docs/PERSONAS.md) | Target user profiles with scenarios |
| [User Journeys](docs/USER_JOURNEYS.md) | Detailed workflow mappings |
| [Success Metrics](docs/METRICS.md) | KPIs and measurement framework |
| [Competitive Analysis](docs/COMPETITIVE_ANALYSIS.md) | Market positioning |
| [Product Roadmap](docs/ROADMAP.md) | Development timeline |

</div>

---

## 🎯 Problem Statement

### The Challenge

Retail sales associates lose **15-20 minutes per shift** searching for inventory information. This creates a cascade of problems:

```
Customer: "Do you have this in size medium?"

┌─────────────────────────────────────────────────────────────┐
│                    CURRENT STATE                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Associate walks to terminal ──────────────────▶ 1 min     │
│  Waits for terminal to be free ────────────────▶ 1-2 min   │
│  Looks up product ─────────────────────────────▶ 30 sec    │
│  Walks to backroom ────────────────────────────▶ 1 min     │
│  Searches for item ────────────────────────────▶ 2-3 min   │
│  Returns to customer ──────────────────────────▶ 1 min     │
│                                                             │
│  TOTAL: 6-8 minutes                                        │
│  CUSTOMER STATUS: Frustrated or Gone                        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Business Impact

| Problem | Impact |
|---------|--------|
| **Frustrated customers** | -15% customer satisfaction scores |
| **Lost sales** | $200-500/day per store from walkouts |
| **Wasted time** | 2-3 hours/shift on non-selling tasks |
| **Inaccurate inventory** | 15% discrepancy between system and reality |

### Research Insights

Based on interviews with 15+ sales associates across 5 retail locations:

- **73%** lose at least one sale per day due to inventory uncertainty
- **89%** would use a mobile app if provided
- **67%** already use personal phones for workarounds
- Average time to answer inventory question: **4.2 minutes**

---

## 💡 Solution

### RetailOps: Inventory in Your Pocket

```
Customer: "Do you have this in size medium?"

┌─────────────────────────────────────────────────────────────┐
│                    WITH RETAILOPS                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Pull phone from pocket ───────────────────────▶ 2 sec     │
│  Tap Scan, point at barcode ───────────────────▶ 5 sec     │
│  See: "3 in backroom, Shelf B4" ───────────────▶ 3 sec     │
│  Tell customer, go retrieve ───────────────────▶ 30 sec    │
│                                                             │
│  TOTAL: 40 seconds                                         │
│  CUSTOMER STATUS: Delighted                                │
│                                                             │
│  ⚡ 90% faster                                              │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Value Proposition

| For | Value |
|-----|-------|
| **Sales Associates** | Answer customers in seconds, not minutes |
| **Store Managers** | Real-time visibility without micromanaging |
| **Customers** | Faster service, accurate information |
| **Business** | Increased sales, reduced labor waste |

---

## ✨ Features

### Core Capabilities

<table>
<tr>
<td width="50%">

#### 📱 Instant Product Lookup
- Barcode scanning via camera
- Search by name, SKU, or barcode
- Real-time stock levels
- Backroom location info

#### 🏪 Multi-Store Visibility
- Check inventory at nearby stores
- Distance-sorted results
- Save the sale when out of stock

</td>
<td width="50%">

#### 📦 BOPIS Order Management
- View pending pickup orders
- Pick and pack workflow
- Customer notification
- Order status tracking

#### 👥 Clienteling
- Customer profiles
- Purchase history
- Preferences and notes
- Personalized service

</td>
</tr>
<tr>
<td width="50%">

#### ⚠️ Smart Alerts
- Low stock notifications
- Out of stock alerts
- Configurable thresholds
- Acknowledge and action

#### 💳 Mobile Checkout
- Scan items to cart
- Customer loyalty integration
- Line-busting during peaks

</td>
<td width="50%">

#### 📊 Dashboard
- Today's KPIs at a glance
- Recent activity feed
- Store-specific metrics

#### 🤖 AI Assistant
- Natural language queries
- Product recommendations
- Styling suggestions

</td>
</tr>
</table>

---

## 📸 Demo

### App Screenshots

| Welcome | Dashboard | Product Lookup |
|---------|-----------|----------------|
| ![Welcome](docs/assets/welcome.png) | ![Dashboard](docs/assets/dashboard.png) | ![Product](docs/assets/product.png) |

| Barcode Scan | Store Availability | Alerts |
|--------------|-------------------|--------|
| ![Scan](docs/assets/scan.png) | ![Stores](docs/assets/stores.png) | ![Alerts](docs/assets/alerts.png) |

### Demo Mode

The app includes a fully functional demo mode that works without a backend connection:

1. Launch the app
2. Tap "Get Started"
3. On login screen, tap "Demo Mode"
4. Explore all features with realistic mock data

---

## 📖 Product Documentation

### For Product Managers / Stakeholders

| Document | Purpose |
|----------|---------|
| [PRD](docs/PRD.md) | Full product requirements, user stories, technical specs |
| [Personas](docs/PERSONAS.md) | Maya (Associate), David (Manager), Carlos (Inventory) |
| [User Journeys](docs/USER_JOURNEYS.md) | 6 key workflows with time savings |
| [Metrics](docs/METRICS.md) | North star metric, KPIs, success criteria |
| [Competitive Analysis](docs/COMPETITIVE_ANALYSIS.md) | Zebra, Lightspeed, Shopify comparison |
| [Roadmap](docs/ROADMAP.md) | Q1-Q4 2025 development plan |

### Key Differentiators

| Differentiator | Description |
|----------------|-------------|
| **Associate-First** | Built for the sales floor, not the back office |
| **BYOD Friendly** | Works on personal iPhones, no hardware needed |
| **Instant Deploy** | No IT project, no enterprise rollout |
| **Offline Capable** | Basic features work without connectivity |
| **AI-Powered** | Natural language inventory queries |

---

## 🛠 Tech Stack

### Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                      iOS Application                        │
│                                                             │
│   ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐      │
│   │ SwiftUI │  │ Combine │  │ Vision  │  │Location │      │
│   │  Views  │  │  State  │  │ Barcode │  │Services │      │
│   └────┬────┘  └────┬────┘  └────┬────┘  └────┬────┘      │
│        │           │           │           │              │
│        └───────────┴───────────┴───────────┘              │
│                         │                                  │
│                    API Client                              │
│                         │                                  │
└─────────────────────────┼──────────────────────────────────┘
                          │ HTTPS/REST
                          │
┌─────────────────────────┼──────────────────────────────────┐
│                    Spring Boot API                         │
│                         │                                  │
│   ┌─────────┐  ┌───────┴───────┐  ┌─────────┐            │
│   │   JWT   │  │  Controllers  │  │ Flyway  │            │
│   │  Auth   │  │   Services    │  │Migration│            │
│   └────┬────┘  └───────┬───────┘  └────┬────┘            │
│        │               │               │                  │
│        └───────────────┼───────────────┘                  │
│                        │                                  │
│                   PostgreSQL                              │
│                                                           │
└───────────────────────────────────────────────────────────┘
```

### Technology Details

| Layer | Technology | Version |
|-------|------------|---------|
| **iOS App** | Swift, SwiftUI | 5.9 |
| **State Management** | Combine, @Observable | - |
| **Barcode Scanning** | AVFoundation, Vision | - |
| **Networking** | URLSession, async/await | - |
| **Backend** | Java, Spring Boot | 17, 3.x |
| **Database** | PostgreSQL | 14+ |
| **Migrations** | Flyway | 9.x |
| **Auth** | JWT (access + refresh tokens) | - |
| **API Docs** | OpenAPI/Swagger | 3.0 |

---

## 🚀 Getting Started

### Prerequisites

- **Xcode 15+** (for iOS development)
- **Java 17+** (for backend)
- **PostgreSQL 14+** (or use H2 for local dev)
- **Docker** (optional)

### Quick Start

#### Option 1: iOS App Only (Demo Mode)

```bash
# Clone the repository
git clone https://github.com/yourusername/retail-operation.git

# Open iOS project
cd retail-operation/ios/Retail_Operation_App
open Retail_Operation_App.xcodeproj

# Run on simulator (Cmd+R)
# Tap "Demo Mode" on login screen
```

#### Option 2: Full Stack

```bash
# Clone the repository
git clone https://github.com/yourusername/retail-operation.git
cd retail-operation

# Start backend with H2 (no database setup needed)
cd backend
SPRING_PROFILES_ACTIVE=local ./gradlew bootRun

# In another terminal, run iOS app
cd ../ios/Retail_Operation_App
open Retail_Operation_App.xcodeproj
# Update API URL in Settings to http://localhost:8080
```

#### Option 3: Docker

```bash
docker-compose up -d
```

### Demo Credentials

When running with `local` profile:

| Email | Password | Role |
|-------|----------|------|
| manager@example.com | password | Manager |
| employee@example.com | password | Employee |

---

## 📁 Project Structure

```
retail-operation/
├── backend/                      # Spring Boot API
│   ├── src/main/java/
│   │   └── com/inventory/backend/
│   │       ├── auth/            # Authentication & JWT
│   │       ├── product/         # Product catalog
│   │       ├── inventory/       # Stock management
│   │       ├── store/           # Store locations
│   │       ├── alert/           # Low stock alerts
│   │       ├── order/           # BOPIS orders
│   │       └── dashboard/       # Analytics
│   └── src/main/resources/
│       └── db/migration/        # Flyway scripts
│
├── ios/                          # iOS Application
│   └── Retail_Operation_App/
│       ├── *View.swift          # SwiftUI views
│       ├── *Models.swift        # Data models
│       ├── *Store.swift         # State management
│       ├── APIClient.swift      # Network layer
│       ├── MockData.swift       # Demo data
│       └── Assets.xcassets/     # Images & icons
│
├── docs/                         # Product Documentation
│   ├── PRD.md                   # Product requirements
│   ├── PERSONAS.md              # User personas
│   ├── USER_JOURNEYS.md         # Workflow maps
│   ├── METRICS.md               # Success metrics
│   ├── COMPETITIVE_ANALYSIS.md  # Market analysis
│   └── ROADMAP.md               # Development roadmap
│
└── api/                          # API Documentation
    └── openapi.yaml             # OpenAPI spec
```

---

## 📊 Success Metrics

### North Star Metric

**Time-to-Answer (TTA)**: How quickly associates can answer inventory questions

| State | Time |
|-------|------|
| Baseline (no app) | 4.2 minutes |
| Target (with RetailOps) | < 30 seconds |
| **Improvement** | **90% faster** |

### Key Performance Indicators

| Category | Metric | Target |
|----------|--------|--------|
| **Adoption** | Daily Active Users | 80% of associates |
| **Efficiency** | Scans per associate/day | 25+ |
| **Accuracy** | Inventory accuracy | 95%+ |
| **Business** | Lost sales recovered | +$200/store/day |
| **Satisfaction** | Associate NPS | > 40 |

---

## 🤝 Contributing

Contributions are welcome! Please read our contributing guidelines before submitting PRs.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

### Built for Retail Teams

**RetailOps** transforms how sales associates interact with inventory,
enabling them to provide faster, more accurate service to every customer.

[Report Bug](https://github.com/yourusername/retail-operation/issues) • [Request Feature](https://github.com/yourusername/retail-operation/issues)

---

*Product Manager Portfolio Project*

</div>
