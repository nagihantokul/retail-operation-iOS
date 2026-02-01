# User Journey Maps
## RetailOps Key Workflows

---

## Overview

This document maps the critical user journeys that RetailOps enables. Each journey includes the trigger, user goal, step-by-step flow, and measurable outcomes.

```
Journey Coverage:

1. Instant Stock Check      ████████████  Core - MVP
2. Cross-Store Lookup       ████████████  Core - MVP
3. Damage Reporting         ████████████  Core - MVP
4. BOPIS Order Fulfillment  ████████████  Core - MVP
5. Mobile Checkout          ████████░░░░  Core - Partial
6. Clienteling              ████████████  Core - MVP
7. Inventory Count          ████████░░░░  Enhanced - v1.1
```

---

## Journey 1: Instant Stock Check

**Persona:** Maya (Sales Associate)
**Trigger:** Customer asks "Do you have this in size medium?"
**Goal:** Answer within 30 seconds without leaving the customer

### Journey Map

```
┌─────────────────────────────────────────────────────────────────┐
│                     INSTANT STOCK CHECK                         │
├─────────┬─────────┬─────────┬─────────┬─────────┬──────────────┤
│ Step 1  │ Step 2  │ Step 3  │ Step 4  │ Step 5  │ Outcome      │
├─────────┼─────────┼─────────┼─────────┼─────────┼──────────────┤
│ Pull    │ Tap     │ Scan    │ View    │ Answer  │ Customer     │
│ Phone   │ Scan    │ Barcode │ Stock   │ Customer│ Satisfied    │
│         │         │         │ Levels  │         │              │
├─────────┼─────────┼─────────┼─────────┼─────────┼──────────────┤
│ 2 sec   │ 3 sec   │ 3 sec   │ 2 sec   │ 10 sec  │ 20 sec total │
└─────────┴─────────┴─────────┴─────────┴─────────┴──────────────┘
```

### Detailed Steps

| Step | User Action | System Response | Time |
|------|-------------|-----------------|------|
| 1 | Pull phone from pocket | App opens (already logged in) | 2 sec |
| 2 | Tap "Scan" button | Camera activates | 3 sec |
| 3 | Point camera at barcode | Barcode recognized, product lookup | 3 sec |
| 4 | View product screen | Shows: Floor (5), Backroom (3), Location: B4 | 2 sec |
| 5 | Tell customer result | "Yes, we have 3 in back. I'll grab one for you." | 10 sec |

### Success Metrics

| Metric | Before | After |
|--------|--------|-------|
| Time to answer | 4.2 min | 20 sec |
| Customer satisfaction | 3.2/5 | 4.5/5 |
| Successful lookups/day | 15 | 50+ |

### Edge Cases

| Scenario | System Behavior |
|----------|-----------------|
| Barcode won't scan | Offer manual SKU/name search |
| Product not found | Show "Not in catalog" with support link |
| Zero stock | Automatically show nearby store availability |

---

## Journey 2: Cross-Store Availability

**Persona:** Maya (Sales Associate)
**Trigger:** Store is out of stock of item customer wants
**Goal:** Find the item at a nearby store and save the sale

### Journey Map

```
Customer: "I really wanted this dress but you don't have my size..."

┌─────────────────────────────────────────────────────────────────┐
│                   CROSS-STORE LOOKUP                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  [Product Screen]                                               │
│  ┌─────────────────────────────────┐                           │
│  │ Silk Midi Dress - Red           │                           │
│  │ Size M                          │                           │
│  │                                 │                           │
│  │ This Store:     0 ❌            │                           │
│  │                                 │                           │
│  │ [Check Other Stores]            │  ← User taps              │
│  └─────────────────────────────────┘                           │
│                    │                                            │
│                    ▼                                            │
│  ┌─────────────────────────────────┐                           │
│  │ Nearby Stores                   │                           │
│  │                                 │                           │
│  │ 📍 Market Street    2 in stock  │  ← 0.8 mi                 │
│  │ 📍 Mission District 1 in stock  │  ← 2.1 mi                 │
│  │ 📍 Oakland Broadway 3 in stock  │  ← 5.4 mi                 │
│  │                                 │                           │
│  │ [Reserve at Market Street]      │  ← User taps              │
│  └─────────────────────────────────┘                           │
│                    │                                            │
│                    ▼                                            │
│  ┌─────────────────────────────────┐                           │
│  │ ✓ Reserved!                     │                           │
│  │                                 │                           │
│  │ Customer: Jane Doe              │                           │
│  │ Store: Market Street            │                           │
│  │ Hold until: Today 6:00 PM       │                           │
│  │                                 │                           │
│  │ [Share with Customer]           │                           │
│  └─────────────────────────────────┘                           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Detailed Steps

| Step | User Action | System Response | Time |
|------|-------------|-----------------|------|
| 1 | See "0 in stock" on product | Shows "Check Other Stores" button | - |
| 2 | Tap "Check Other Stores" | Fetches nearby store inventory | 2 sec |
| 3 | View list of stores with stock | Sorted by distance, shows quantities | - |
| 4 | Tap "Reserve" on preferred store | Creates hold, notifies other store | 3 sec |
| 5 | Share confirmation | SMS/email to customer | 2 sec |

### Business Impact

| Metric | Value |
|--------|-------|
| Average sale saved | $89 |
| Cross-store reserves/day | 3-5 per store |
| Customer return rate | +15% |

---

## Journey 3: Damage Reporting

**Persona:** Maya (Sales Associate)
**Trigger:** Find damaged merchandise on the floor
**Goal:** Remove from inventory quickly and accurately

### Journey Map

```
┌─────────────────────────────────────────────────────────────────┐
│                     DAMAGE REPORTING                            │
├─────────┬─────────┬─────────┬─────────┬─────────┬──────────────┤
│ Spot    │ Open    │ Scan    │ Select  │ Submit  │ Set Aside    │
│ Damage  │ Adjust  │ Item    │ Reason  │ Report  │ for Vendor   │
├─────────┼─────────┼─────────┼─────────┼─────────┼──────────────┤
│ 0 sec   │ 5 sec   │ 5 sec   │ 5 sec   │ 3 sec   │ 2 sec        │
└─────────┴─────────┴─────────┴─────────┴─────────┴──────────────┘
                                                    Total: 20 sec
```

### Reason Codes

| Code | Description | Requires Photo |
|------|-------------|----------------|
| DAMAGED_FLOOR | Found damaged on sales floor | Recommended |
| DAMAGED_BACKROOM | Found damaged in backroom | Recommended |
| CUSTOMER_RETURN | Damaged item returned | Required |
| DEFECTIVE | Manufacturing defect | Required |
| EXPIRED | Past sell-by date | No |

### Audit Trail

Every adjustment creates:
```json
{
  "adjustmentId": "ADJ-2024-001234",
  "timestamp": "2024-01-26T14:30:00Z",
  "user": "maya.chen@store.com",
  "store": "Union Square",
  "product": "SKU-12345",
  "delta": -1,
  "reason": "DAMAGED_FLOOR",
  "photoUrl": "s3://damages/ADJ-2024-001234.jpg",
  "notes": "Torn seam on sleeve"
}
```

---

## Journey 4: BOPIS Order Fulfillment

**Persona:** Maya (Sales Associate)
**Trigger:** Notification of new online order for store pickup
**Goal:** Pick, pack, and notify customer efficiently

### Journey Map

```
┌─────────────────────────────────────────────────────────────────┐
│                  BOPIS ORDER FULFILLMENT                        │
└─────────────────────────────────────────────────────────────────┘

┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   NEW ORDER  │────▶│  PREPARING   │────▶│    READY     │
│              │     │              │     │              │
│ Order #1234  │     │ Picking...   │     │ Notify Cust. │
└──────────────┘     └──────────────┘     └──────────────┘
       │                    │                    │
       ▼                    ▼                    ▼
┌──────────────────────────────────────────────────────────────┐
│ Step 1: View Order Details                                    │
│ ┌──────────────────────────────────────────────────────────┐ │
│ │ Order #ORD-2024-001                                      │ │
│ │ Customer: John Smith                                     │ │
│ │ Phone: (415) 555-0101                                    │ │
│ │                                                          │ │
│ │ Items:                                                   │ │
│ │ ☐ Wool Blazer - Black (1)         Location: A3         │ │
│ │ ☐ Cotton T-Shirt - White (2)      Location: B7         │ │
│ │                                                          │ │
│ │ [Start Picking]                                          │ │
│ └──────────────────────────────────────────────────────────┘ │
│                                                               │
│ Step 2: Pick Items (scan each)                               │
│ ┌──────────────────────────────────────────────────────────┐ │
│ │ ✓ Wool Blazer - Black (1)         SCANNED               │ │
│ │ ☐ Cotton T-Shirt - White (2)      PENDING               │ │
│ │                                                          │ │
│ │ [Scan Next Item]                                         │ │
│ └──────────────────────────────────────────────────────────┘ │
│                                                               │
│ Step 3: Complete & Notify                                    │
│ ┌──────────────────────────────────────────────────────────┐ │
│ │ ✓ All items picked!                                      │ │
│ │                                                          │ │
│ │ [Mark Ready & Notify Customer]                           │ │
│ │                                                          │ │
│ │ Customer will receive:                                   │ │
│ │ "Your order is ready for pickup at Union Square!"       │ │
│ └──────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────┘
```

### Order States

| State | Description | Actions Available |
|-------|-------------|-------------------|
| NEW | Just placed online | View, Start Picking |
| PREPARING | Being picked | Scan items, Mark problem |
| READY | Ready for customer | Notify, Print label |
| PICKED_UP | Customer collected | Rate experience |
| CANCELLED | Order cancelled | Return items to floor |

### Metrics

| Metric | Target |
|--------|--------|
| Pick time | < 5 minutes |
| Order accuracy | 99.5% |
| Customer wait (after notify) | < 2 hours |

---

## Journey 5: Mobile Checkout (Line-Busting)

**Persona:** Maya (Sales Associate)
**Trigger:** Long queue at registers during peak hours
**Goal:** Complete transaction on the sales floor

### Journey Map

```
┌─────────────────────────────────────────────────────────────────┐
│                    MOBILE CHECKOUT                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Step 1: Start Checkout                                        │
│  ┌─────────────────────────────────┐                           │
│  │ [New Checkout]                  │                           │
│  └─────────────────────────────────┘                           │
│                    │                                            │
│                    ▼                                            │
│  Step 2: Scan Items                                            │
│  ┌─────────────────────────────────┐                           │
│  │ Cart (3 items)          $247.80 │                           │
│  │                                 │                           │
│  │ Wool Blazer         1   $149.00 │                           │
│  │ Cotton T-Shirt      2    $39.80 │                           │
│  │ Leather Belt        1    $59.00 │                           │
│  │                                 │                           │
│  │ [Scan More] [Checkout]          │                           │
│  └─────────────────────────────────┘                           │
│                    │                                            │
│                    ▼                                            │
│  Step 3: Link Customer (Optional)                              │
│  ┌─────────────────────────────────┐                           │
│  │ 👤 Jane Doe                     │                           │
│  │ Loyalty: Gold (2,450 pts)       │                           │
│  │ ✓ Apply 500 pts (-$5.00)        │                           │
│  └─────────────────────────────────┘                           │
│                    │                                            │
│                    ▼                                            │
│  Step 4: Payment                                               │
│  ┌─────────────────────────────────┐                           │
│  │ Total: $242.80                  │                           │
│  │                                 │                           │
│  │ [Tap to Pay] [Card] [Cash]      │                           │
│  └─────────────────────────────────┘                           │
│                    │                                            │
│                    ▼                                            │
│  Step 5: Receipt                                               │
│  ┌─────────────────────────────────┐                           │
│  │ ✓ Payment Complete!             │                           │
│  │                                 │                           │
│  │ [Email Receipt] [Print] [Done]  │                           │
│  └─────────────────────────────────┘                           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Journey 6: Clienteling

**Persona:** Maya (Sales Associate)
**Trigger:** Regular customer walks in
**Goal:** Provide personalized service using customer history

### Journey Map

```
Customer: "Hi, I was here last month..."

┌─────────────────────────────────────────────────────────────────┐
│                     CLIENTELING                                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Step 1: Search Customer                                       │
│  ┌─────────────────────────────────┐                           │
│  │ 🔍 jane doe                     │                           │
│  │                                 │                           │
│  │ Jane Doe                        │                           │
│  │ jane.doe@email.com              │                           │
│  │ Last visit: Jan 15              │                           │
│  └─────────────────────────────────┘                           │
│                    │                                            │
│                    ▼                                            │
│  Step 2: View Profile                                          │
│  ┌─────────────────────────────────┐                           │
│  │ 👤 Jane Doe                     │                           │
│  │                                 │                           │
│  │ Preferences:                    │                           │
│  │ • Neutral colors                │                           │
│  │ • Size M                        │                           │
│  │ • Prefers dresses               │                           │
│  │                                 │                           │
│  │ Recent Purchases:               │                           │
│  │ • Cashmere Sweater ($89.90)     │                           │
│  │ • Silk Scarf ($45.00)           │                           │
│  │                                 │                           │
│  │ Notes:                          │                           │
│  │ "Usually shops for work attire" │                           │
│  └─────────────────────────────────┘                           │
│                    │                                            │
│                    ▼                                            │
│  Step 3: Personalized Service                                  │
│                                                                 │
│  "Hi Jane! Great to see you again.                             │
│   We just got new spring dresses that                          │
│   would go perfectly with that cashmere                        │
│   sweater you bought last month!"                              │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Journey Metrics Summary

| Journey | Time Saved | Frequency | Business Impact |
|---------|------------|-----------|-----------------|
| Stock Check | 3.5 min | 50+/day | Customer satisfaction |
| Cross-Store | 5 min | 3-5/day | $250-$450 saved sales |
| Damage Report | 4 min | 2-3/day | Inventory accuracy |
| BOPIS | 3 min | 10-20/day | Faster fulfillment |
| Checkout | 2 min | 5-10/day | Line reduction |
| Clienteling | N/A | 5-10/day | Customer loyalty |

---

<div align="center">

*Journey maps based on user research and workflow analysis*

**Last Updated:** January 2025

</div>
