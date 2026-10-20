# 🕰️ Vinifera Marketplace — AI-Powered Vintage Appraisals, Antique Auctions & Collector Marketplace

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.100+-009688?style=for-the-badge&logo=fastapi&logoColor=white)](https://fastapi.tiangolo.com)
[![Firebase](https://img.shields.io/badge/Firebase-Auth_%7C_Firestore_%7C_Storage-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Python](https://img.shields.io/badge/Python-3.11+-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://python.org)
[![License](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)](LICENSE)

---

## 🌟 Executive Overview

**Vinifera Marketplace** is an enterprise-grade mobile and cloud ecosystem engineered for antique collectors, estate liquidators, and vintage enthusiasts. The platform solves the perennial challenge of identifying, pricing, and trading rare vintage heirlooms—such as historic timepieces, mid-century lamps, vintage jewelry, antique furniture, and art objects.

### Core Value Proposition & Computer Vision Appraisals

1. **Instant AI-Powered Visual Appraisal:**
   - A user discovers or inherits a vintage artifact (e.g., an heirloom pocket watch, antique brass lamp, or retro ceramic).
   - By capturing a photo through the app, the appraisal pipeline extracts visual features, identifies material composition and stylistic era, and references historical auction sales records.
   - The user immediately receives an estimated fair-market value, valuation confidence score, and price-bracket analysis.

2. **Peer-to-Peer & Verified Dealer Commerce:**
   - Once appraised, users can instantly list items on the marketplace with pre-populated provenance and suggested pricing.
   - Verified antique dealers and independent collectors can place direct bids, submit formal offers, or purchase via escrow checkout.

---

## 🏛️ Multi-Tier Architecture

The repository is organized as a clean monorepo powering three specialized mobile suites and a high-performance backend:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                       MULTI-TIER CLIENT APPLICATIONS                        │
│                                                                             │
│   ┌───────────────────────┐ ┌───────────────────────┐ ┌─────────────────┐   │
│   │   Collector / Buyer   │ │    Antique Dealer     │ │  Admin Portal   │   │
│   │     (apps/customer)   │ │     (apps/dealer)     │ │   (apps/admin)  │   │
│   └───────────┬───────────┘ └───────────┬───────────┘ └────────┬────────┘   │
└───────────────┼─────────────────────────┼──────────────────────┼────────────┘
                ▼                         ▼                      ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                    HIGH-THROUGHPUT FASTAPI BACKEND                          │
│                                                                             │
│   • Computer Vision Appraisal Pipeline & Historical Auction Indices         │
│   • Asynchronous Offer State-Machine & In-App Real-Time Negotiation         │
│   • Seller Escrow Ledger & Automated Payout Calculations                    │
│   • Push Notification Hub via Firebase Cloud Messaging                      │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                    FIREBASE & CLUSTER CLOUD SERVICES                        │
│             Firestore Database  •  Firebase Auth  •  Cloud Storage           │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 1. Collector Mobile Suite (`apps/customer`)
- **Discovery Feed:** Curated categories (Horology, Mid-Century Lighting, Vintage Porcelain, Rare Artifacts).
- **Camera Appraisal Scanner:** Guided multi-angle photo capture with instant AI-driven price estimate.
- **Negotiation Hub:** Counter-offer engine, dynamic status updates, and encrypted dealer messaging.
- **Order Tracking:** Integrated milestone-based shipment and appraisal certificate verification.

### 2. Antique Dealer Mobile Suite (`apps/dealer`)
- **Inventory & Catalog Management:** Bulk listing tools, authenticity cert uploads, condition grading notes.
- **Inbound Offer Desk:** Accept, reject, or counter buyer offers with expiry timers.
- **Financial Ledger & Wallet:** Track gross revenue, pending escrow balances, transaction receipts, and payout histories.
- **Event Participation:** Virtual antique exhibition registrations and live collector showcases.

### 3. Administrator Mobile Suite (`apps/admin`)
- **Listing Governance & Authenticity Review:** Flagged counterfeit review, prohibited goods moderation.
- **Event Management:** Virtual collector events, featured dealer spotlights, and platform promotions.
- **Dispute Resolution:** Multi-party transaction arbitration and escrow freeze/release overrides.

### 4. FastAPI Asynchronous Backend (`backend/app`)
- **High-Performance Endpoints:** Fully asynchronous Python 3.11 with Pydantic v2 data validation schemas.
- **Modular Routers:** `items.py`, `offers.py`, `orders.py`, `events.py`, `wallet.py`, `chat.py`, `notifications.py`.
- **Stateless Authentication:** Firebase Admin SDK token verification with role-based access control (RBAC).

---

## 🛠️ Complete Technology Stack

| Domain | Technology | Implementation Detail |
|---|---|---|
| **Mobile Frontend** | Flutter 3.x / Dart 3.x | Multi-app architecture (`apps/customer`, `apps/dealer`, `apps/admin`) |
| **State & Navigation** | Navigator 2.0 & Provider | Reactive state trees with offline cache layers |
| **Backend API** | FastAPI / Python 3.11+ | Asynchronous REST endpoints, ASGI uvicorn runner |
| **Authentication** | Firebase Authentication | Secure JWT Bearer tokens with custom role claims |
| **Database** | Cloud Firestore | Real-time NoSQL collections with strict document security rules |
| **Object Storage** | Firebase Cloud Storage | Multi-resolution compressed image assets with CDN distribution |
| **Messaging** | Firestore Streams | Sub-second real-time negotiation chat between buyers and dealers |

---

## 🏛️ Engineering Provenance

Architected, engineered, and maintained by **Muhammad Ali** as Principal Mobile Architect.
