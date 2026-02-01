# RetailOps - PM Portfolio Presentation

---

## Slide 1: Title

<div align="center">

# RetailOps
### Mobile Inventory Management for Retail

**Nagihan Tokul** | Product Manager

*Transforming how sales associates serve customers*

</div>

---

## Slide 2: The Problem

### "Do you have this in size medium?"

```
Current Process: 4-7 minutes
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Walk to terminal       ████████░░░░░░░░░░░░  1 min
Wait for terminal      ████████████░░░░░░░░  2 min
Look up product        ████░░░░░░░░░░░░░░░░  30 sec
Walk to backroom       ████████░░░░░░░░░░░░  1 min
Search shelves         ████████████████░░░░  3 min
Return to customer     ████████░░░░░░░░░░░░  1 min

Result: Customer frustrated or gone 😠
```

**Impact**: $200-500 lost sales per store per day

---

## Slide 3: Research Insights

### What Associates Told Us

| Finding | Stat |
|---------|------|
| Lose at least 1 sale/day from inventory issues | **73%** |
| Would use a mobile app if provided | **89%** |
| Already use personal phones for workarounds | **67%** |
| Average time to answer inventory question | **4.2 min** |

*Based on 15 associate interviews across 5 retail locations*

---

## Slide 4: The Solution

### RetailOps: Inventory in Your Pocket

```
With RetailOps: 30 seconds
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Pull phone             ██░░░░░░░░░░░░░░░░░░  2 sec
Scan barcode           ████░░░░░░░░░░░░░░░░  5 sec
See stock location     ██░░░░░░░░░░░░░░░░░░  3 sec
Tell customer          ████████████████████  20 sec

Result: Customer delighted 😊
```

**⚡ 90% faster**

---

## Slide 5: User Personas

### Who We're Building For

<table>
<tr>
<td width="50%">

**Maya Chen** | Sales Associate

- Age 24, 2 years retail
- 50+ inventory checks/day
- Goal: Help customers fast

*"I just want to help customers without running to the back every 5 minutes."*

</td>
<td width="50%">

**David Park** | Store Manager

- Age 38, 12 years retail
- 15 direct reports
- Goal: Real-time visibility

*"I need to know what's happening without micromanaging."*

</td>
</tr>
</table>

---

## Slide 6: Key Features

### Built for the Sales Floor

| Feature | Value |
|---------|-------|
| 📱 **Barcode Scanner** | Instant product lookup via camera |
| 🏪 **Cross-Store Check** | Find inventory at nearby locations |
| ⚠️ **Low Stock Alerts** | Proactive notifications |
| 📦 **BOPIS Orders** | Pick and pack workflow |
| 💳 **Mobile Checkout** | Line-busting during peaks |
| 👥 **Clienteling** | Customer profiles & history |

---

## Slide 7: User Journey

### Save-the-Sale Flow

```
Customer: "I want this dress but you don't have my size"

         ┌──────────────┐
         │ Out of Stock │
         └──────┬───────┘
                │
                ▼
    ┌───────────────────────┐
    │ Check Other Stores    │
    └───────────┬───────────┘
                │
                ▼
    ┌───────────────────────┐
    │ Market St: 2 in stock │ ← 0.8 miles away
    │ [Reserve for Customer]│
    └───────────┬───────────┘
                │
                ▼
         💰 Sale Saved: $89
```

---

## Slide 8: Success Metrics

### How We Measure Success

| Metric | Baseline | Target |
|--------|----------|--------|
| **Time-to-Answer** | 4.2 min | < 30 sec |
| **Daily Active Users** | 0% | 80% |
| **Inventory Accuracy** | 85% | 95% |
| **Lost Sales Recovered** | $0 | +$200/day/store |

### North Star: Time-to-Answer (TTA)

---

## Slide 9: Technical Approach

### Architecture

```
┌─────────────────────────┐
│     iOS App (Swift)     │
│   SwiftUI • Combine     │
└───────────┬─────────────┘
            │ REST API
            ▼
┌─────────────────────────┐
│  Spring Boot Backend    │
│   Java 17 • JWT Auth    │
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│     PostgreSQL DB       │
└─────────────────────────┘
```

**Key Decision**: Native iOS for camera performance and retail iPhone prevalence

---

## Slide 10: Roadmap

### Phased Delivery

```
Q1 2025 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ ✅ DONE
│
├── Authentication & user management
├── Barcode scanning & product lookup
├── Cross-store inventory check
├── Low stock alerts
├── BOPIS order management
└── Demo mode for testing

Q2 2025 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ NEXT
│
├── Push notifications
├── Offline mode
└── Manager approvals

Q3 2025 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ PLANNED
│
├── Android app
├── AI assistant (full)
└── Analytics dashboard
```

---

## Slide 11: Results

### Projected Impact

| Metric | Before | After | Change |
|--------|--------|-------|--------|
| Time to answer | 4.2 min | 30 sec | **-88%** |
| Lost sales/day | $350 | $100 | **-71%** |
| Associate NPS | 32 | 45 | **+41%** |

### ROI Calculation

```
50 stores × $250 saved/day × 365 days = $4.5M/year
```

---

## Slide 12: Key Learnings

### What I'd Tell Past-Me

1. **Start with store visits, not competitors**
   - The real insight came from watching associates work

2. **Demo mode is a product feature**
   - Built for testing, became critical for onboarding

3. **Mobile-first = thumb-first**
   - One-handed use is essential on the sales floor

4. **Offline isn't optional for retail**
   - Store Wi-Fi is unreliable; sync is v2 priority

---

## Slide 13: Documentation

### Portfolio Artifacts

| Document | Purpose |
|----------|---------|
| **PRD** | Full product requirements, user stories |
| **Personas** | Maya, David, Carlos with scenarios |
| **User Journeys** | 6 detailed workflow maps |
| **Metrics** | KPIs and success criteria |
| **Competitive Analysis** | Zebra, Shopify, Lightspeed |
| **Roadmap** | Q1-Q4 2025 development plan |

All available at: `github.com/yourusername/retail-operation/docs`

---

## Slide 14: Thank You

<div align="center">

# Questions?

**Nagihan Tokul**

📧 your.email@example.com
💼 linkedin.com/in/yourprofile
💻 github.com/yourusername

---

*I'm excited to bring this approach—user research, data-driven prioritization, and hands-on execution—to your product challenges.*

</div>

---

## Appendix A: Feature Prioritization (RICE)

| Feature | Reach | Impact | Confidence | Effort | Score |
|---------|-------|--------|------------|--------|-------|
| Barcode Scanner | 5 | 5 | 5 | 2 | 9.0 |
| Product Search | 5 | 5 | 5 | 2 | 9.0 |
| Cross-Store Lookup | 4 | 5 | 5 | 3 | 7.5 |
| Low Stock Alerts | 4 | 4 | 5 | 2 | 6.5 |
| BOPIS Orders | 3 | 4 | 4 | 3 | 5.0 |
| Mobile Checkout | 3 | 5 | 3 | 4 | 4.5 |

---

## Appendix B: Competitive Landscape

| Competitor | Strength | Weakness | Our Advantage |
|------------|----------|----------|---------------|
| Zebra | Enterprise scale | Expensive, complex | BYOD, instant deploy |
| Lightspeed | Beautiful UI | Desktop-first | Mobile-first |
| Shopify POS | E-comm integration | Checkout-focused | Inventory depth |
| Oracle Retail | Full suite | $500K+, slow deploy | Weeks not months |

---

## Appendix C: Demo Instructions

### Try It Yourself

1. Clone: `git clone github.com/yourusername/retail-operation`
2. Open: `cd ios/Retail_Operation_App && open *.xcodeproj`
3. Run: Press Cmd+R in Xcode
4. Demo: Tap "Demo Mode" on login screen
5. Explore: All features work with mock data

---
