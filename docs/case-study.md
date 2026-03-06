# 📦 Marketplace Logistics Intelligence System
### Operational Analytics for Brazilian E-Commerce Delivery Performance

<p align="left">
  <img src="https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white"/>
  <img src="https://img.shields.io/badge/Pandas-150458?style=for-the-badge&logo=pandas&logoColor=white"/>
  <img src="https://img.shields.io/badge/Power%20BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black"/>
  <img src="https://img.shields.io/badge/Jupyter-F37626?style=for-the-badge&logo=jupyter&logoColor=white"/>
</p>

> **An end-to-end operational analytics system built on the Brazilian Olist E-Commerce dataset — transforming raw logistics data into a three-layer intelligence dashboard that monitors delivery performance, audits seller risk, and surfaces predictive insights for marketplace operations.**

---

## 📌 Table of Contents

1. [Project Overview](#1-project-overview)
2. [Business Problem](#2-business-problem)
3. [Dataset Description](#3-dataset-description)
4. [Data Pipeline & Preparation](#4-data-pipeline--preparation)
5. [Feature Engineering](#5-feature-engineering)
6. [Dashboard Architecture](#6-dashboard-architecture)
7. [Key Insights](#7-key-insights)
8. [Business Recommendations](#8-business-recommendations)
9. [Tools & Technologies](#9-tools--technologies)
10. [Project Impact](#10-project-impact)

---

## 1. Project Overview

In e-commerce, logistics performance is one of the most visible and consequential measures of marketplace quality. A delayed delivery doesn't just frustrate a customer — it erodes platform trust, reduces repeat purchase likelihood, and places real revenue at risk.

This project builds a **Marketplace Logistics Intelligence System** on top of the Brazilian Olist E-Commerce dataset. It covers the full analyst workflow: ingesting and cleaning multi-table relational data, engineering operational metrics, exploring patterns across sellers and geographies, and delivering a three-page Power BI dashboard designed for real stakeholder use.

The result is not just a set of charts — it is a structured **operational monitoring system** that gives logistics teams, account managers, and executives the visibility they need to act on delivery performance data confidently and quickly.

---

## 2. Business Problem

Marketplace logistics operations involve hundreds or thousands of independent sellers, multiple regional carriers, and millions of unique delivery routes. When delivery failures occur, pinpointing *where* and *why* is operationally difficult without a unified data layer.

The core challenges this project addresses:

- **No consolidated view of delivery performance** — late delivery rates were scattered across order data with no aggregated monitoring.
- **Inability to distinguish seller-caused vs. carrier-caused delays** — without this attribution, interventions are misdirected.
- **High-risk sellers not identified proactively** — problems were being discovered reactively, after customer complaints.
- **No route-level bottleneck visibility** — certain seller-to-customer state corridors were structurally unreliable, but undetected.
- **Financial impact unquantified** — leadership had no dollar figure attached to delivery failures.

**The analytical objective:** Transform raw logistics data into a system that answers — *What is failing? Where? Who is responsible? How much is it costing?*

---

## 3. Dataset Description

This project uses the **Brazilian E-Commerce Public Dataset by Olist**, available on [Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce). The dataset represents real, anonymized transactions from a multi-seller Brazilian online marketplace spanning 2016–2018.

| Table | Contents |
|---|---|
| `olist_orders` | Order lifecycle timestamps: purchase, approval, carrier pickup, delivery |
| `olist_order_items` | Line items per order with seller ID, price, and freight value |
| `olist_sellers` | Seller location by state |
| `olist_customers` | Customer location by city and state |
| `olist_order_reviews` | Customer satisfaction scores (1–5 stars) and written reviews |
| `olist_products` | Product categories and physical dimensions |
| `olist_geolocation` | ZIP-code-level geographic coordinates |

**Scale:** 100,000+ orders · ~3,000 sellers · 27 Brazilian states · 2016–2018

The dataset provides a realistic representation of a multi-seller marketplace logistics environment, making it well-suited for operational analytics work.

---

## 4. Data Pipeline & Preparation

A structured ETL pipeline was built to take the raw relational tables through to a clean, analysis-ready dataset. Each step was documented in Jupyter Notebooks for reproducibility.

```
╔═══════════════╗     ╔══════════════════╗     ╔══════════════════════╗     ╔═════════════════════╗     ╔══════════════════╗     ╔═══════════════════════╗
║   Raw CSV     ║     ║  Data Ingestion  ║     ║  Cleaning & Type     ║     ║  Multi-Table        ║     ║    Feature       ║     ║  Analytical Dataset   ║
║   Files       ║────▶║  & Validation    ║────▶║  Standardization     ║────▶║  Merging            ║────▶║  Engineering     ║────▶║  Export               ║
║               ║     ║                  ║     ║                      ║     ║                     ║     ║                  ║     ║                       ║
║ olist_orders  ║     ║ • Schema check   ║     ║ • datetime64 cast    ║     ║ orders → items      ║     ║ is_late          ║     ║ orders_analytical.csv ║
║ olist_sellers ║     ║ • Row counts     ║     ║ • Null flagging       ║     ║ items  → sellers    ║     ║ delay_days       ║     ║ seller_summary.csv    ║
║ olist_items   ║     ║ • Type inference ║     ║ • Status filtering   ║     ║ orders → customers  ║     ║ seller_late_rate  ║     ║ route_matrix.csv      ║
║ olist_reviews ║     ║                  ║     ║ • Deduplication      ║     ║ orders → reviews    ║     ║ revenue_at_risk   ║     ║                       ║
╚═══════════════╝     ╚══════════════════╝     ╚══════════════════════╝     ╚═════════════════════╝     ╚══════════════════╝     ╚═══════════════════════╝
                                                                                                                                           │
                                                                                                                                           ▼
                                                                                                                             ╔═════════════════════════╗
                                                                                                                             ║   Power BI Dashboard    ║
                                                                                                                             ║                         ║
                                                                                                                             ║ 📊 Control Tower        ║
                                                                                                                             ║ 👤 Seller Risk Audit    ║
                                                                                                                             ║ 🤖 AI Forecasting       ║
                                                                                                                             ╚═════════════════════════╝
```

### Cleaning Steps

- **Timestamp standardization:** All date columns converted to `datetime64` for accurate time-delta calculations.
- **Status filtering:** Orders in non-terminal statuses (`canceled`, `unavailable`) excluded from delivery calculations — retained separately for volume reporting.
- **Missing value handling:**
  - `order_delivered_customer_date` — null for undelivered orders; kept null and flagged as "at-risk" in revenue metrics rather than dropped.
  - `review_score` — ~15% of orders had no review; excluded from satisfaction correlations, not imputed as zero.
- **Deduplication:** Multi-item orders normalized to a single order-level record to prevent double-counting in delay metrics.
- **Data quality flags:** Orders where estimated delivery date preceded purchase timestamp were flagged as data anomalies and excluded from delay analysis.

### Table Merging

The core analytical table was built by joining:
`orders` → `order_items` → `sellers` → `customers` → `reviews`

This produced a single flat table with one row per order, containing all delivery, seller, customer, and satisfaction fields needed for downstream analysis.

---

## 5. Feature Engineering

Raw timestamps alone are insufficient for operational analytics. The following features were engineered to create meaningful logistics performance metrics:

| Feature | Definition | Why It Matters |
|---|---|---|
| `is_late` | 1 if actual delivery > estimated delivery date | Core binary KPI for all delay analysis |
| `delay_days` | Actual delivery − estimated delivery (days) | Quantifies delay severity per order |
| `seller_handling_time` | Carrier pickup date − order approval date | Measures seller fulfillment speed |
| `carrier_transit_time` | Customer delivery − carrier pickup date | Measures carrier logistics performance |
| `delay_responsibility` | Categorical: `seller` / `carrier` / `on-time` | Enables targeted intervention by responsible party |
| `seller_late_rate` | % of seller's orders that are late | Aggregated seller risk score |
| `route_key` | `seller_state → customer_state` | Geographic corridor identifier for bottleneck analysis |
| `revenue_at_risk` | Order value for late or undelivered orders | Translates operational failures into financial impact |
| `seller_category` | Segmentation: Elite / At-Risk / Critical | Enables tiered seller management |

These features are the foundation of every visualization and insight in the dashboard. They transform raw operational data into metrics that logistics teams and executives can act on directly.

---

## 6. Dashboard Architecture

The dashboard was designed as a **three-layer intelligence system**, where each page serves a distinct stakeholder audience and decision cadence.

---

### Page 1 — Marketplace Delivery Operations Control Tower

**Audience:** VP of Operations, Logistics Directors, Senior Management

**Purpose:** A single-screen operational heartbeat providing the full picture of marketplace delivery health. This page answers the question: *"How is the marketplace performing right now, and where are the biggest problems?"*

**Key Metrics Tracked:**

| Metric | Value |
|---|---|
| Total Orders | 111K |
| Late Delivery Rate | 6.58% |
| Revenue at Risk | $1.91M |
| Avg Delivery Time | 12.01 days |

**Visualizations:**
- **Seller vs. Carrier Delay Diagnosis** — Stacked bar showing the split between seller handling time and carrier transit time by state. Immediately identifies whether delay is a seller fulfillment problem or a carrier network problem.
- **Top 10 High-Risk Delivery Routes** — Routes ranked by late delivery rate. AM→AL, BA→AC, and CE→AM are the highest-risk corridors, each approaching 100% late delivery rates.
- **Route Bottleneck Matrix** — Heatmap of seller state × customer state late delivery rates. Dark cells expose structurally problematic corridors for logistics network planning.
- **Late Rate % by Month** — Trend line identifying seasonal patterns. Spikes in Q1 and Q4 suggest volume-driven capacity constraints.
- **Top 10 Late Sellers by Revenue** — Combines order volume and late rate to produce a revenue-weighted risk ranking for account management prioritization.

![Operations Control Tower Dashboard](Images/Overview_Dashboard.png)

---

### Page 2 — Sellers Performance & Risk Audit

**Audience:** Seller Success Team, Account Managers, Operations Analysts

**Purpose:** A drill-down into individual and segmented seller performance. This page answers: *"Which sellers are causing delivery failures, how severe is the risk, and is the issue on the seller's side or the carrier's side?"*

**Key Metrics Tracked:**

| Metric | Value |
|---|---|
| Total Sellers | 2,970 |
| Elite Sellers | 1,788 |
| At-Risk Sellers | 342 |
| Critical Sellers | 412 |

**Visualizations:**
- **Seller Late Rate by State** — AM and MA sellers have materially higher late rates than the national average, pointing to regional logistics gaps rather than individual seller quality issues.
- **Total Sellers Driving Revenue Risk** — Top sellers ranked by absolute revenue at risk. The top 10 sellers account for a disproportionate share of total financial exposure.
- **Seller Performance Risk Map** — Scatter plot of order volume vs. late rate, segmenting sellers into four quadrants: *Low Impact*, *Reliable High-Volume*, *Emerging Risk*, and *Critical Operational Risk*.
- **Seller vs. Carrier Delay Breakdown** — Attribution view by state, enabling accountability conversations with both sellers and carrier partners.
- **Seller Count by Category** — 2.9K Top Performers vs. 1.3K High-Risk sellers, providing a strategic distribution view for resource allocation.
- **Seller Performance Audit Table** — Operational table of at-risk sellers with their category, state, late rate, and total orders — designed for direct use by account management teams.

![Seller Performance & Risk Audit Dashboard](Images/Seller_Audit_Dashboard.png)

---

### Page 3 — AI Logistics Risk Intelligence & Forecasting

**Audience:** Data & Analytics Teams, Strategic Planning, Logistics Innovation

**Purpose:** Forward-looking risk intelligence for anticipating and preventing delivery failures before they occur. This page answers: *"Where is performance heading, and which sellers or regions will become high-risk next?"*

**Visualizations:**
- **Late Delivery Rate Forecast** — 12-month projected late delivery rate based on historical trend modeling. Enables proactive capacity planning ahead of high-risk periods.
- **Operational Delay Anomaly Detection** — Time series from Jan 2017–Oct 2018 with flagged anomaly points. Distinguishes statistically normal delay levels from significant operational disruptions — four major spikes were detected, primarily in early 2018.
- **Weekly Delivery Risk Trend** — Short-cycle view showing intra-year fluctuation. The peak around weeks 9–11 (~20% late rate) identifies a recurring early-year risk window.
- **Future High-Risk Sellers** — Predictive bar chart ranking sellers by projected delay volume based on trajectory modeling. Enables pre-emptive seller success intervention before performance deteriorates.
- **Regional Delivery Risk Heatmap** — Month × state matrix of late rates. Surfaces persistent regional problem areas (AM's 100% February rate) vs. transient spikes elsewhere.
- **AI Operational Summary** — Plain-language synthesis of key risk signals: late delivery risk scales with order volume, operational disruptions drove spikes in 2017–2018, and delivery risk is concentrated among specific sellers and regions.

![AI Logistics Intelligence Dashboard](Images/AI_Insights_Dashboard.png)

---

### How the Dashboard Drives Data-Driven Decisions

The three-layer structure maps directly to how decisions are made at different organizational levels:

| Dashboard Layer | Audience | Decision Cadence | Key Decision Enabled |
|---|---|---|---|
| Control Tower | Executive / Director | Weekly / Monthly | Resource allocation, escalation triggers |
| Seller Audit | Account Managers / Ops | Daily / Weekly | Seller outreach, performance plans |
| AI Forecasting | Analytics / Strategy | Monthly / Quarterly | Capacity planning, risk prevention |

This architecture means the right person gets the right level of information without requiring them to filter through data that isn't relevant to their role.

---

## 7. Key Insights

**📌 $1.91M in revenue is currently at risk due to delivery delays.**
At a 6.58% late delivery rate across 111K orders, approximately 7,300 orders failed to arrive on time. The financial exposure is material and directly improvable through operational changes.

**📌 A small number of sellers drive a disproportionate share of delivery failures.**
The top 10 sellers by revenue at risk account for a significant portion of total marketplace exposure. This is a classic Pareto distribution — targeted intervention on a small seller segment can produce outsized improvement in overall performance.

**📌 412 sellers are classified as Critical risk — high volume combined with high late rates.**
This is the most dangerous segment: these sellers have enough order volume to meaningfully impact marketplace metrics, and their late rates are elevated enough to drive sustained customer dissatisfaction.

**📌 Specific delivery routes are structurally unreliable, not randomly delayed.**
AM→AL, BA→AC, and CE→AM consistently approach 100% late delivery rates. This is a logistics infrastructure issue, not a seller or carrier performance issue — it requires network investment, not performance management.

**📌 Delay responsibility is split between sellers and carriers, and varies by region.**
In AM and MA, seller handling time is the dominant delay driver. In SP, carrier transit time is more influential. This means a single intervention strategy won't work — the fix must be tailored by region.

**📌 Delivery delays directly correlate with poor customer satisfaction.**
Orders arriving late consistently generate lower review scores, creating a compounding business risk: late deliveries generate complaints *and* reduce the likelihood of repeat purchases.

**📌 Delay spikes are recurring and calendar-predictable.**
Anomaly detection identified major disruptions clustering around Q1 and high-volume sale periods in 2017–2018. The predictability of these spikes means they can be anticipated and mitigated with surge capacity protocols.

---

## 8. Business Recommendations

### Immediate Actions (0–30 Days)

- **Launch a Critical Seller Improvement Program** — Contact the 412 critical-risk sellers with individual performance scorecards. Set clear improvement targets with defined consequences (reduced platform visibility or suspension) for non-compliance.
- **Activate proactive route alerts** — Flag all orders on the top 10 high-risk routes for proactive customer communication. Set realistic expectations *before* deliveries are late rather than managing complaints afterward.

### Short-Term Initiatives (30–90 Days)

- **Enforce a seller handling time policy** — Introduce a maximum 2 business-day handling time from order approval to carrier pickup, monitored via the seller audit dashboard with automated warnings for non-compliance.
- **Renegotiate carrier SLAs for structurally underserved states** — For AL, AC, and AP, either renegotiate carrier contracts to reflect realistic transit times or adjust customer-facing estimated delivery dates to reduce expectation mismatches.
- **Introduce a seller onboarding risk screen** — New sellers from high-risk states (AM, MA) should verify logistics partnerships and fulfillment capacity before going live, preventing new at-risk sellers from entering the marketplace.

### Strategic Initiatives (90+ Days)

- **Invest in regional logistics partnerships** — For persistently underserved states, explore dedicated fulfillment partnerships or last-mile carrier investments to bring delivery reliability up to the network average.
- **Build a surge capacity protocol for Q1 and peak sale periods** — The forecasting dashboard shows late rates climbing predictably during these windows. Pre-approved temporary logistics capacity (additional carriers, extended seller handling windows) should be activated before these periods, not during them.
- **Improve delivery date estimation accuracy** — The current estimation model appears to set optimistic delivery promises. Tightening estimates by route and seller category would reduce the gap between promise and actual delivery, directly improving satisfaction scores even before operational changes take effect.

---

## 9. Tools & Technologies

| Category | Tool | Usage |
|---|---|---|
| **Data Processing** | Python 3.x | Core analytics pipeline |
| **Data Manipulation** | Pandas, NumPy | Cleaning, merging, feature engineering |
| **Exploration & Analysis** | Jupyter Notebook | EDA, documentation, reproducibility |
| **Visualization** | Matplotlib, Seaborn | EDA charts and heatmaps |
| **Dashboard** | Power BI | Interactive operational dashboard |
| **Version Control** | Git / GitHub | Code versioning and portfolio hosting |

---

## 10. Project Impact

This project demonstrates what operational analytics looks like in practice — not just exploratory charts, but a structured system that connects raw data to decisions.

The key contributions of this work:

- **Operational visibility where none existed** — The dashboard consolidates delivery performance, seller risk, and logistics routes into a single system. Before this, identifying a high-risk seller required manual investigation across multiple data sources.

- **Financial quantification of operational failures** — Attaching a $1.91M revenue-at-risk figure to delivery delays makes the business case for logistics investment concrete and actionable for leadership.

- **Accountability at the right level** — By attributing delays to either seller handling or carrier transit (and varying this by region), the system ensures that interventions are targeted correctly — sellers don't get blamed for carrier failures, and carriers don't absorb the impact of seller underperformance.

- **Proactive rather than reactive operations** — The forecasting and anomaly detection layer shifts the team from responding to delivery failures to anticipating and preventing them, which is a fundamentally different (and more valuable) operational posture.

The analytical framework built here is directly transferable to any multi-seller marketplace environment. The pipeline, feature engineering logic, and dashboard structure can scale to larger datasets and extended time horizons with minimal modification.

---

---

## 📎 Dataset Source

[Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) — released under CC BY-NC-SA 4.0

---

*Built by [Manas Paliwal](https://github.com/Manaspaliwal18) · [LinkedIn](https://linkedin.com/in/manaspaliwal18)*
