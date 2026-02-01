# Product Manager Portfolio

<div align="center">

# RetailOps
## Mobile Inventory Management Platform

---

**Case Study: Transforming Retail Operations**

*From 4 minutes to 30 seconds: How I designed a mobile solution that reduces inventory lookup time by 90%*

---

</div>

## About Me

**Nagihan Tokul**
Product Manager | Building user-centric solutions at the intersection of technology and business

- Passionate about retail technology and operational efficiency
- Experience in end-to-end product development (research → design → launch)
- Technical background with hands-on development skills (iOS, Backend)

---

## Project Overview

| Attribute | Detail |
|-----------|--------|
| **Role** | Product Manager (Solo - End to End) |
| **Timeline** | 8 weeks (Q4 2024 - Q1 2025) |
| **Platform** | iOS Native + Spring Boot Backend |
| **Status** | MVP Complete, Ready for Pilot |

### The One-Liner

> *A mobile app that empowers retail sales associates to answer customer inventory questions in under 30 seconds, instead of the typical 4+ minutes.*

---

## 🎯 The Problem

### Discovery: What I Observed

During store visits and associate interviews, I noticed a consistent pattern:

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│   Customer: "Do you have this in a medium?"                    │
│                                                                 │
│   Associate: "Let me check..."                                  │
│                                                                 │
│   ┌─────────────────────────────────────────────────────────┐  │
│   │  Walk to terminal         1 min   ████                  │  │
│   │  Wait for availability    1-2 min ████████              │  │
│   │  Look up product          30 sec  ██                    │  │
│   │  Walk to backroom         1 min   ████                  │  │
│   │  Search for item          2-3 min ████████████          │  │
│   │  Return to customer       1 min   ████                  │  │
│   └─────────────────────────────────────────────────────────┘  │
│                                                                 │
│   Total: 6-8 minutes                                           │
│   Result: Customer frustrated or gone                          │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Research Methodology

| Method | Sample | Key Insight |
|--------|--------|-------------|
| **Contextual Inquiry** | 5 stores, 4 hrs each | Associates average 15-20 inventory walks/day |
| **User Interviews** | 15 associates | 73% lose sales daily due to inventory uncertainty |
| **Competitive Analysis** | 6 products | Existing solutions are desktop-first or enterprise-only |
| **Survey** | 25 respondents | 89% would use a mobile app if provided |

### Problem Statement

**For** retail sales associates
**Who** need to answer customer inventory questions quickly
**The** current process requires walking to fixed terminals and backrooms
**Which results in** 4+ minute delays, frustrated customers, and lost sales
**Unlike** having information at their fingertips
**Our solution** provides instant mobile access to inventory data

### Quantifying the Impact

| Metric | Current State | Business Impact |
|--------|---------------|-----------------|
| Time to answer inventory question | 4.2 minutes | Lost productivity |
| Associates who lose sales daily | 73% | Revenue leakage |
| Customer satisfaction (inventory) | 3.2/5 | NPS decline |
| Inventory accuracy | 85% | Stock discrepancies |

**Conservative estimate**: Each store loses $200-500/day from inventory-related walkouts.

---

## 👥 User Personas

### Primary: The Sales Associate

<table>
<tr>
<td width="200px">

**Maya Chen**
Age 24 | 2 years retail

*"I just want to help customers without running to the back every 5 minutes."*

</td>
<td>

| Attribute | Detail |
|-----------|--------|
| **Goals** | Help customers fast, hit sales targets |
| **Frustrations** | Walking to terminal, backroom mismatches |
| **Tech comfort** | High - uses iPhone daily |
| **Usage pattern** | 50+ inventory checks/day |

</td>
</tr>
</table>

### Secondary: The Store Manager

<table>
<tr>
<td width="200px">

**David Park**
Age 38 | 12 years retail

*"I need visibility without micromanaging."*

</td>
<td>

| Attribute | Detail |
|-----------|--------|
| **Goals** | Meet targets, maintain accuracy |
| **Frustrations** | No real-time visibility, approval bottlenecks |
| **Key needs** | Dashboard, audit trails, alerts |
| **Usage pattern** | 10-15 checks/day |

</td>
</tr>
</table>

---

## 💡 The Solution

### Vision

> Enable every sales associate to answer "Do you have this in stock?" within 30 seconds, from anywhere on the sales floor.

### Key Features (Prioritized via RICE)

| Feature | Reach | Impact | Confidence | Effort | Score | Priority |
|---------|-------|--------|------------|--------|-------|----------|
| Barcode Scanner | High | High | High | Low | 9.0 | P0 |
| Product Search | High | High | High | Low | 9.0 | P0 |
| Cross-Store Lookup | Med | High | High | Med | 7.5 | P0 |
| Low Stock Alerts | Med | Med | High | Low | 6.5 | P1 |
| BOPIS Orders | Med | Med | Med | Med | 5.0 | P1 |
| Mobile Checkout | Med | High | Med | High | 4.5 | P1 |
| AI Assistant | Low | Med | Low | High | 2.5 | P2 |

### User Journey: Instant Stock Check

```
BEFORE                              AFTER
──────                              ─────

Customer asks                       Customer asks
    │                                   │
    ▼                                   ▼
Walk to terminal (1 min)            Pull out phone (2 sec)
    │                                   │
    ▼                                   ▼
Wait in queue (1-2 min)             Tap Scan (3 sec)
    │                                   │
    ▼                                   ▼
Look up product (30 sec)            Point at barcode (3 sec)
    │                                   │
    ▼                                   ▼
Walk to backroom (1 min)            See: "3 in back, Shelf B4"
    │                                   │
    ▼                                   ▼
Search shelves (2-3 min)            Tell customer, retrieve (30 sec)
    │                                   │
    ▼                                   ▼
Return to customer (1 min)          ✓ Done
    │
    ▼
Total: 6-8 minutes                  Total: 40 seconds
Customer: 😠                         Customer: 😊

                                    ⚡ 90% faster
```

### Cross-Store Save-the-Sale

```
┌─────────────────────────────────────────┐
│  Customer wants item we don't have...   │
└─────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────┐
│  Tap "Check Other Stores"               │
└─────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────┐
│  📍 Market Street    2 in stock (0.8mi) │
│  📍 Mission District 1 in stock (2.1mi) │
│  📍 Oakland Broadway 3 in stock (5.4mi) │
└─────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────┐
│  "I can reserve it for you at Market   │
│   Street. You can pick it up today!"   │
└─────────────────────────────────────────┘
                    │
                    ▼
           💰 Sale Saved: $89
```

---

## 📱 Product Design

### Information Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        RetailOps                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐       │
│  │  Home   │  │  Scan   │  │ Orders  │  │Settings │       │
│  │Dashboard│  │ Search  │  │ BOPIS   │  │ Profile │       │
│  └────┬────┘  └────┬────┘  └────┬────┘  └────┬────┘       │
│       │            │            │            │             │
│       ▼            ▼            ▼            ▼             │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐       │
│  │Checkout │  │ Product │  │ Order   │  │ Store   │       │
│  │Customers│  │ Detail  │  │ Detail  │  │ Select  │       │
│  │ Alerts  │  │ Stores  │  │ Picking │  │ API URL │       │
│  │Transfers│  │ Adjust  │  │         │  │         │       │
│  └─────────┘  └─────────┘  └─────────┘  └─────────┘       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Key Screens

| Screen | Purpose | Key Decisions |
|--------|---------|---------------|
| **Dashboard** | At-a-glance KPIs and actions | Grid layout for quick access |
| **Scanner** | Barcode lookup | Full-screen camera, instant results |
| **Product Detail** | Stock info and cross-store | Location info prominent |
| **Alerts** | Low stock items | Sortable, acknowledgeable |
| **Checkout** | Mobile POS | Scan-to-cart workflow |
| **Customers** | Clienteling | Purchase history, preferences |

### Design Principles

1. **Speed over features**: Every tap counts on a busy sales floor
2. **Offline resilience**: Demo mode works without connectivity
3. **Glanceable**: Critical info visible in < 2 seconds
4. **One-handed**: Usable while holding merchandise

---

## 📊 Success Metrics

### North Star Metric

**Time-to-Answer (TTA)**: How quickly associates can answer inventory questions

| State | Time | Status |
|-------|------|--------|
| Baseline | 4.2 minutes | Measured |
| Target | < 30 seconds | Goal |
| Achieved (Demo) | ~20 seconds | ✅ |

### KPI Framework

| Category | Metric | Target | Measurement |
|----------|--------|--------|-------------|
| **Adoption** | DAU/MAU | > 60% | Analytics |
| **Engagement** | Scans/associate/day | 25+ | App telemetry |
| **Efficiency** | Time-to-answer | < 30 sec | Time study |
| **Accuracy** | Inventory accuracy | 95%+ | Cycle count |
| **Business** | Lost sales recovered | +$200/day/store | Sales data |
| **Satisfaction** | Associate NPS | > 40 | Survey |

### Pilot Success Criteria

| Phase | Duration | Criteria |
|-------|----------|----------|
| **Pilot** (4 stores) | 4 weeks | 70% DAU, NPS > 20, < 60s TTA |
| **Regional** (50 stores) | 8 weeks | 80% retention, < 30s TTA |
| **Full Deploy** | 12 weeks | 80% DAU, measurable sales impact |

---

## 🛠 Technical Execution

### Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      iOS Application                        │
│                      (SwiftUI + Combine)                    │
├─────────────────────────────────────────────────────────────┤
│  Views          State           Services                    │
│  ──────         ─────           ────────                    │
│  SwiftUI        @Observable     APIClient                   │
│  Components     Managers        Keychain                    │
│                 Stores          Location                    │
└───────────────────────┬─────────────────────────────────────┘
                        │ REST/HTTPS
                        ▼
┌─────────────────────────────────────────────────────────────┐
│                    Spring Boot API                          │
│                    (Java 17)                                │
├─────────────────────────────────────────────────────────────┤
│  Controllers    Services        Repository                  │
│  ──────────     ────────        ──────────                  │
│  REST API       Business        JPA/Hibernate               │
│  JWT Auth       Logic           PostgreSQL                  │
└─────────────────────────────────────────────────────────────┘
```

### Technical Decisions

| Decision | Options Considered | Choice | Rationale |
|----------|-------------------|--------|-----------|
| Mobile Platform | Native iOS, React Native, Flutter | Native iOS | Best camera/performance, target audience uses iPhone |
| Backend | Node.js, Spring Boot, Django | Spring Boot | Enterprise-ready, strong typing, team familiarity |
| Auth | Session, JWT, OAuth | JWT | Stateless, mobile-friendly, refresh tokens |
| Offline | None, Full, Partial | Partial (Demo Mode) | MVP scope, full sync in v2 |

### What I Built

| Component | Technology | Lines of Code |
|-----------|------------|---------------|
| iOS App | Swift 5.9, SwiftUI | ~3,500 |
| Backend API | Java 17, Spring Boot | ~2,000 |
| Database | PostgreSQL + Flyway | 15 migrations |
| Documentation | Markdown | 6 documents |

---

## 🚀 Roadmap

### Delivered (Q1 2025)

- ✅ Authentication & user management
- ✅ Barcode scanning & product lookup
- ✅ Cross-store inventory check
- ✅ Low stock alerts
- ✅ BOPIS order management
- ✅ Mobile checkout (cart)
- ✅ Clienteling (customer profiles)
- ✅ Demo mode for testing

### Next Up (Q2-Q3 2025)

| Feature | Priority | Business Value |
|---------|----------|----------------|
| Push Notifications | P0 | Real-time alerts |
| Offline Mode | P0 | Rural store support |
| Android App | P1 | 30% more coverage |
| Manager Approvals | P1 | Loss prevention |
| AI Assistant (full) | P2 | Differentiation |

---

## 📈 Results & Learnings

### Projected Impact

| Metric | Baseline | Projected | Impact |
|--------|----------|-----------|--------|
| Time-to-answer | 4.2 min | 30 sec | **-88%** |
| Lost sales/store/day | $350 | $100 | **-71%** |
| Associate satisfaction | 3.2/5 | 4.5/5 | **+40%** |
| Inventory accuracy | 85% | 95% | **+12%** |

### Key Learnings

1. **Start with the pain, not the solution**
   - Initial hypothesis was about "better inventory software"
   - Research revealed it was about "time on feet" and "customer perception"

2. **Demo mode is a feature, not a shortcut**
   - Built for testing, became critical for sales demos and onboarding
   - Users can explore without backend dependency

3. **Mobile-first means thumb-first**
   - Every interaction designed for one-handed use
   - Critical info visible without scrolling

4. **Offline isn't optional for retail**
   - Wi-Fi in stores is unreliable
   - V2 priority: full offline with sync

### What I'd Do Differently

| Area | Original Approach | What I'd Change |
|------|-------------------|-----------------|
| Research | Started with competitors | Start with store shadowing |
| Scope | Tried to include checkout early | Focus on lookup, add checkout later |
| Testing | Manual testing only | Add unit/UI tests from start |
| Analytics | Deferred to v2 | Bake in from day 1 |

---

## 🤝 Collaboration

### Cross-Functional Work

| Stakeholder | Collaboration |
|-------------|---------------|
| **Store Operations** | Requirements, pilot stores, feedback |
| **IT/Security** | Auth requirements, API standards |
| **Design** | UI patterns, accessibility review |
| **Engineering** | Architecture, code reviews |
| **Finance** | ROI modeling, budget |

### Communication Artifacts

- Weekly status emails to stakeholders
- Bi-weekly demo sessions
- PRD with living updates
- Slack channel for pilot feedback

---

## 📚 Portfolio Artifacts

### Documentation Produced

| Document | Purpose | Link |
|----------|---------|------|
| PRD | Full product requirements | [PRD.md](PRD.md) |
| Personas | User profiles and scenarios | [PERSONAS.md](PERSONAS.md) |
| User Journeys | Workflow maps | [USER_JOURNEYS.md](USER_JOURNEYS.md) |
| Metrics | Success criteria | [METRICS.md](METRICS.md) |
| Competitive Analysis | Market positioning | [COMPETITIVE_ANALYSIS.md](COMPETITIVE_ANALYSIS.md) |
| Roadmap | Development timeline | [ROADMAP.md](ROADMAP.md) |

### Technical Deliverables

- Fully functional iOS app (SwiftUI)
- Production-ready backend API (Spring Boot)
- Database schema with migrations
- API documentation (OpenAPI)

---

## 📞 Contact

**Nagihan Tokul**

- GitHub: [github.com/yourusername](https://github.com/yourusername)
- LinkedIn: [linkedin.com/in/yourprofile](https://linkedin.com/in/yourprofile)
- Email: your.email@example.com

---

<div align="center">

*Thank you for reviewing my portfolio!*

**I'm excited to bring this same approach—user research, data-driven prioritization, and hands-on execution—to your product challenges.**

</div>
