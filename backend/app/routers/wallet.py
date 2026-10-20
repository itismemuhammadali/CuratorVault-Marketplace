import datetime
from typing import Optional, List
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from firebase_admin import firestore

router = APIRouter(prefix="/wallet", tags=["wallet"])

class PayoutRequest(BaseModel):
    amount: float
    payoutMethod: str = "bank_transfer"
    accountDetails: Optional[dict] = None

class PaymentMethodRequest(BaseModel):
    cardType: str = "visa"
    cardNumber: str
    expiry: str
    holderName: str

@router.get("")
async def get_wallet_overview():
    """Retrieve wallet balance, pending escrow funds, and transaction history."""
    db = firestore.client()
    wallet_doc = db.collection("wallets").document("default_wallet").get()
    
    if not wallet_doc.exists:
        initial_wallet = {
            "availableBalance": 4850.0,
            "escrowBalance": 1450.0,
            "currency": "USD",
            "transactions": [
                {
                    "id": "tx_101",
                    "title": "Sale: Victorian Mahogany Chair",
                    "type": "credit",
                    "amount": 1200.0,
                    "status": "completed",
                    "date": "Oct 05, 2026",
                },
                {
                    "id": "tx_102",
                    "title": "Escrow Hold: Victorian Pocket Watch",
                    "type": "escrow_hold",
                    "amount": 1450.0,
                    "status": "in_escrow",
                    "date": "Oct 06, 2026",
                },
                {
                    "id": "tx_103",
                    "title": "Payout to Bank (*4821)",
                    "type": "debit",
                    "amount": 2500.0,
                    "status": "completed",
                    "date": "Sep 28, 2026",
                }
            ],
            "payoutMethods": [
                {
                    "id": "pm_1",
                    "type": "bank",
                    "bankName": "Barclays Private Bank",
                    "accountLast4": "4821",
                    "isDefault": True,
                },
                {
                    "id": "pm_2",
                    "type": "card",
                    "brand": "Visa",
                    "last4": "8842",
                    "isDefault": False,
                }
            ]
        }
        db.collection("wallets").document("default_wallet").set(initial_wallet)
        return initial_wallet
    
    return wallet_doc.to_dict()

@router.post("/payout")
async def request_payout(payload: PayoutRequest):
    """Submit a payout request from available balance."""
    db = firestore.client()
    wallet_ref = db.collection("wallets").document("default_wallet")
    wallet_doc = wallet_ref.get()
    
    current_data = wallet_doc.to_dict() if wallet_doc.exists else {"availableBalance": 4850.0, "transactions": []}
    available = current_data.get("availableBalance", 0.0)
    
    if payload.amount > available:
        raise HTTPException(status_code=400, detail="Insufficient available balance for payout.")
    
    new_balance = available - payload.amount
    new_tx = {
        "id": f"tx_payout_{int(datetime.datetime.utcnow().timestamp())}",
        "title": f"Payout via {payload.payoutMethod.replace('_', ' ').title()}",
        "type": "debit",
        "amount": payload.amount,
        "status": "processing",
        "date": datetime.datetime.utcnow().strftime("%b %d, %Y"),
    }
    
    transactions = current_data.get("transactions", [])
    transactions.insert(0, new_tx)
    
    wallet_ref.set({
        **current_data,
        "availableBalance": new_balance,
        "transactions": transactions,
    }, merge=True)
    
    return {"success": True, "message": "Payout requested successfully", "newBalance": new_balance, "transaction": new_tx}

@router.get("/escrow")
async def get_escrow_details():
    """Retrieve escrow transactions holding buyer funds pending delivery inspection."""
    db = firestore.client()
    escrow_docs = db.collection("escrow_holds").stream()
    escrows = [doc.to_dict() for doc in escrow_docs]
    
    if not escrows:
        default_escrows = [
            {
                "id": "esc_101",
                "orderId": "ORD-2026-9481",
                "itemTitle": "Victorian Pocket Watch (1885)",
                "amount": 1450.0,
                "buyerName": "Eleanor Vance",
                "status": "Inspection Period (2 Days Remaining)",
                "deliveryDate": "Oct 06, 2026",
                "canRelease": True,
            },
            {
                "id": "esc_102",
                "orderId": "ORD-2026-8832",
                "itemTitle": "Mid-Century Modern Lounge Chair",
                "amount": 1500.0,
                "buyerName": "Marcus Sterling",
                "status": "In Transit via White Glove Courier",
                "deliveryDate": "Estimated Oct 09, 2026",
                "canRelease": False,
            }
        ]
        for item in default_escrows:
            db.collection("escrow_holds").document(item["id"]).set(item)
        return {"escrows": default_escrows, "totalInEscrow": 2950.0}
    
    total = sum(e.get("amount", 0.0) for e in escrows)
    return {"escrows": escrows, "totalInEscrow": total}
