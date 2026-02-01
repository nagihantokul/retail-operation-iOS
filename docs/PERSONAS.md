# User Personas
## RetailOps Target Users

---

## Overview

RetailOps serves three primary user segments within retail organizations. Our design decisions prioritize the **Sales Associate** as the primary user, with features that also benefit Managers and Inventory Specialists.

```
                    Usage Frequency
                          ^
                          |
        Sales Associate   |  *****  (50+ times/day)
                          |
        Inventory Spec.   |  ***    (20-30 times/day)
                          |
        Store Manager     |  **     (10-15 times/day)
                          |
                          +-------------------------->
                                Feature Complexity
```

---

## Primary Persona: The Sales Associate

### Maya Chen
**"I just want to help customers without running to the back every 5 minutes."**

<table>
<tr>
<td width="30%">

**Demographics**
| Attribute | Detail |
|-----------|--------|
| Age | 24 |
| Role | Sales Associate |
| Department | Women's Apparel |
| Experience | 2 years retail |
| Store | Union Square, SF |
| Shift | 10am - 6pm |

</td>
<td width="70%">

**A Day in Maya's Life**

| Time | Activity | Pain Point |
|------|----------|------------|
| 10:00 | Opens store, checks floor | No visibility into overnight shipments |
| 11:30 | Customer asks about size | Must walk to terminal, 3 min round trip |
| 1:00 | Finds damaged item | Paper form takes 5 minutes |
| 3:00 | Customer wants item we don't have | Can't check other stores easily |
| 5:30 | Long checkout line | Can't help bust lines |

</td>
</tr>
</table>

### Goals & Motivations

| Goal | Why It Matters |
|------|----------------|
| Provide fast answers | Customer satisfaction drives repeat visits |
| Hit sales targets | Commission is 15% of Maya's income |
| Look knowledgeable | Professional pride and career growth |
| Minimize wasted steps | Physical fatigue from 8-hour shifts |

### Frustrations & Pain Points

> "The worst is when a customer is ready to buy, but I can't confirm we have their size. By the time I check and come back, they've lost interest."

| Pain Point | Frequency | Impact |
|------------|-----------|--------|
| Walking to check inventory | 15-20x/day | 45 min wasted |
| Terminal always in use | 5-10x/day | Customer waits |
| Backroom doesn't match system | 3-5x/day | Lost credibility |
| Can't check other stores | 2-3x/day | Lost sale |
| Damaged item paperwork | 1-2x/day | Boring, slow |

### Technology Profile

| Aspect | Detail |
|--------|--------|
| Personal Phone | iPhone 14 Pro |
| Tech Comfort | High - digital native |
| Apps Used Daily | Instagram, TikTok, Venmo, Uber |
| Work Tools | Legacy POS terminal, walkie-talkie |
| Learning Style | Video tutorials, peer learning |

### Key Scenarios

**Scenario 1: The Stock Question**
```
Customer: "Do you have this in a medium?"

WITHOUT RetailOps:
├── Walk to terminal (1 min)
├── Wait for terminal (1 min)
├── Look up product (30 sec)
├── Walk to backroom (1 min)
├── Search for item (2 min)
└── Return to customer (1 min)
    Total: 6-7 minutes

WITH RetailOps:
├── Pull phone from pocket (2 sec)
├── Scan barcode (3 sec)
├── View: "3 in backroom, Shelf B4" (5 sec)
└── Tell customer, go retrieve (30 sec)
    Total: 40 seconds
```

**Scenario 2: The Save-the-Sale**
```
Customer found perfect dress but store is out of her size.

WITHOUT RetailOps:
├── "Sorry, we don't have it"
├── Customer leaves disappointed
└── Lost sale: $89

WITH RetailOps:
├── Tap "Check Other Stores"
├── "Market Street has 2 in stock, 0.8 miles away"
├── "I can reserve it for you right now"
└── Customer delighted, will pick up today
    Saved sale: $89 + future loyalty
```

### Success Metrics for Maya

| Metric | Before | After Target |
|--------|--------|--------------|
| Time per inventory lookup | 4.2 min | 30 sec |
| Customers helped/hour | 8 | 12 |
| Lost sales from stock issues | 2/day | 0.5/day |
| Steps walked/shift | 12,000 | 8,000 |

---

## Secondary Persona: The Store Manager

### David Park
**"I need to know what's happening on my floor without micromanaging."**

<table>
<tr>
<td width="30%">

**Demographics**
| Attribute | Detail |
|-----------|--------|
| Age | 38 |
| Role | Store Manager |
| Experience | 12 years retail |
| Team Size | 15 associates |
| Store Volume | $2.5M/year |
| Hours | 8am - 6pm + on-call |

</td>
<td width="70%">

**Responsibilities**
| Area | % Time |
|------|--------|
| People management | 35% |
| Customer escalations | 20% |
| Inventory & operations | 25% |
| Reporting & admin | 15% |
| Training | 5% |

</td>
</tr>
</table>

### Goals & Motivations

| Goal | Why It Matters |
|------|----------------|
| Meet monthly sales targets | Bonus tied to performance |
| Maintain 95%+ inventory accuracy | Corporate mandate |
| Develop team members | Succession planning |
| Minimize shrinkage | Direct P&L impact |

### What David Needs from RetailOps

| Need | Feature | Benefit |
|------|---------|---------|
| Real-time visibility | Dashboard with live metrics | Know issues before they escalate |
| Accountability | Adjustment audit trail | Trust but verify |
| Approval workflow | Large adjustment sign-off | Prevent errors/fraud |
| Team performance | Usage analytics | Coach effectively |
| Exception alerts | Out-of-stock notifications | Proactive management |

### Key Scenarios

**Scenario: Morning Briefing**
```
7:45 AM - David arrives, opens RetailOps dashboard

Sees at a glance:
├── 3 low stock alerts (needs attention)
├── 5 BOPIS orders ready for pickup
├── Yesterday: 127 scans by team (good engagement)
└── 1 large adjustment pending approval

Actions in 5 minutes:
├── Approves adjustment (legit - customer return)
├── Assigns low stock to opening associate
└── Ready for morning huddle with data
```

---

## Tertiary Persona: The Inventory Specialist

### Carlos Rodriguez
**"Accuracy is everything. One wrong count cascades into a hundred problems."**

| Attribute | Detail |
|-----------|--------|
| Age | 45 |
| Role | Inventory Control Specialist |
| Experience | 8 years in inventory |
| Responsibility | 3 stores in district |
| Schedule | Tue-Sat, early mornings |

### Primary Tasks

| Task | Frequency | Current Tool | Pain Point |
|------|-----------|--------------|------------|
| Cycle counts | Daily | Handheld scanner | Heavy, slow |
| Discrepancy research | Daily | Excel + walking | Time-consuming |
| Shrinkage investigation | Weekly | Paper reports | Hard to correlate |
| Receiving verification | Per shipment | Clipboard | Error-prone |

### What Carlos Needs

| Need | Feature |
|------|---------|
| Efficient counting | Scan-and-count workflow |
| Discrepancy tracking | Variance reports |
| Historical data | Movement audit trail |
| Cross-store view | District-level visibility |

---

## Persona Comparison Matrix

| Attribute | Maya (Associate) | David (Manager) | Carlos (Inventory) |
|-----------|------------------|-----------------|-------------------|
| **Primary goal** | Serve customers fast | Meet store targets | Maintain accuracy |
| **Usage frequency** | 50+ times/day | 10-15 times/day | 20-30 times/day |
| **Key features** | Scan, search, checkout | Dashboard, approvals | Counts, variance |
| **Success metric** | Time saved | Sales impact | Accuracy % |
| **Tech comfort** | High | Medium | Medium |
| **Training needed** | 15 minutes | 30 minutes | 1 hour |

---

## Anti-Personas (Who We're NOT Building For)

| Anti-Persona | Why Not |
|--------------|---------|
| **Warehouse Worker** | Different workflow, need WMS |
| **E-commerce Manager** | Online-only, different tools |
| **Finance Team** | Need ERP, not mobile app |
| **End Customer** | B2B focus, not B2C |

---

## Research Methodology

### Data Sources

| Source | Sample Size | Method |
|--------|-------------|--------|
| Associate interviews | 15 | 45-min sessions |
| Manager surveys | 8 | Online questionnaire |
| Store observations | 5 stores | 4-hour shadowing |
| Competitive user reviews | 200+ | App store analysis |

### Key Research Insights

1. **73%** of associates lose at least one sale/day due to inventory uncertainty
2. **89%** would use a mobile app if provided
3. **67%** currently use personal phones for "workarounds"
4. Average time to answer inventory question: **4.2 minutes**
5. **82%** of managers want real-time visibility into team activity

---

<div align="center">

*Personas based on user research conducted Q4 2024*

**Last Updated:** January 2025

</div>
