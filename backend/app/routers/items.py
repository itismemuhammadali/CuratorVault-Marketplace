import uuid
from datetime import datetime
from typing import Optional, List, Dict, Any
from fastapi import APIRouter, HTTPException, Depends, Header, Query
from pydantic import BaseModel, Field
import firebase_admin
from firebase_admin import firestore
from app.config import settings

router = APIRouter(tags=["Items & Marketplace"])

# Models
class ItemCreateRequest(BaseModel):
    title: str
    description: Optional[str] = ""
    category: str = "Furniture"
    price: float = 0.0
    estimatedValueMin: Optional[float] = None
    estimatedValueMax: Optional[float] = None
    condition: str = "Excellent"
    era: str = "Victorian"
    materials: List[str] = []
    imageUrl: Optional[str] = None
    images: List[str] = []
    status: str = "Live"  # Live, Draft, Sold
    sellerId: Optional[str] = None
    sellerName: Optional[str] = None
    sellerType: str = "dealer"  # dealer, customer

class ScanRequest(BaseModel):
    imagePath: Optional[str] = None
    imageBase64: Optional[str] = None
    categoryHint: Optional[str] = None

class SaveFindRequest(BaseModel):
    title: str
    category: str = "Furniture"
    estimatedPriceMin: float = 1200.0
    estimatedPriceMax: float = 1800.0
    authenticityScore: int = 94
    era: str = "Late 19th Century (c. 1880-1900)"
    condition: str = "Excellent - Original Patina"
    materials: List[str] = ["Solid Mahogany", "Brass Joinery"]
    provenance: str = "English Victorian Estate"
    imageUrl: Optional[str] = None
    notes: Optional[str] = None

def get_current_user_id(authorization: Optional[str] = Header(None)) -> str:
    """Extracts or mocks current user ID based on emulator / bearer token."""
    if authorization and authorization.startswith("Bearer "):
        token = authorization.split("Bearer ")[1].strip()
        try:
            from firebase_admin import auth
            decoded = auth.verify_id_token(token)
            return decoded.get("uid", "mock_user_1")
        except Exception:
            return token if len(token) < 50 else "mock_user_1"
    return "mock_user_1"

# Initial seed data for Marketplace Items
DEFAULT_MARKETPLACE_ITEMS = [
    {
        "id": "item_1",
        "title": "Victorian Mahogany Armchair",
        "category": "Furniture",
        "price": 1450.0,
        "estimatedValueMin": 1200.0,
        "estimatedValueMax": 1800.0,
        "authenticityScore": 96,
        "era": "Late Victorian (c. 1880)",
        "condition": "Excellent",
        "views": 142,
        "status": "Live",
        "sellerId": "dealer_london_antiques",
        "sellerName": "London Heritage Antiques",
        "sellerRating": 4.9,
        "imageUrl": "assets/images/home_product_one.png",
        "images": ["assets/images/home_product_one.png"],
        "description": "Exquisite hand-carved mahogany armchair upholstered in genuine archival damask silk. Stamped and numbered joinery.",
        "materials": ["Solid Honduran Mahogany", "Silk Damask", "Brass Casters"],
        "provenance": "Private Collection, Cotswolds, UK",
        "dimensions": "95cm H x 68cm W x 72cm D",
        "createdAt": datetime.now().isoformat()
    },
    {
        "id": "item_2",
        "title": "Antique Oak Rolltop Cabinet",
        "category": "Furniture",
        "price": 2200.0,
        "estimatedValueMin": 2000.0,
        "estimatedValueMax": 2600.0,
        "authenticityScore": 92,
        "era": "Edwardian (c. 1910)",
        "condition": "Very Good",
        "views": 98,
        "status": "Live",
        "sellerId": "dealer_london_antiques",
        "sellerName": "London Heritage Antiques",
        "sellerRating": 4.9,
        "imageUrl": "assets/images/home_product_four.png",
        "images": ["assets/images/home_product_four.png"],
        "description": "Solid English quarter-sawn oak tambour roll-top desk cabinet with original functioning locking mechanism and skeleton key.",
        "materials": ["Quarter-sawn Oak", "Cast Iron Hardware"],
        "provenance": "Yorkshire Estate Sale",
        "dimensions": "120cm H x 110cm W x 80cm D",
        "createdAt": datetime.now().isoformat()
    },
    {
        "id": "item_3",
        "title": "Porcelain Dynasty Vase Collection",
        "category": "Pottery",
        "price": 850.0,
        "estimatedValueMin": 800.0,
        "estimatedValueMax": 1200.0,
        "authenticityScore": 95,
        "era": "Qing Dynasty (Late 19th Century)",
        "condition": "Mint",
        "views": 210,
        "status": "Live",
        "sellerId": "dealer_oriental_arts",
        "sellerName": "Imperial Artifacts Co.",
        "sellerRating": 4.8,
        "imageUrl": "assets/images/home_product_three.png",
        "images": ["assets/images/home_product_three.png"],
        "description": "Hand-painted blue and white porcelain baluster vase with double circle base mark and delicate underglaze floral motifs.",
        "materials": ["Fine Kaolin Porcelain", "Cobalt Glaze"],
        "provenance": "Acquired at Sotheby's 1994",
        "dimensions": "34cm H x 18cm Diameter",
        "createdAt": datetime.now().isoformat()
    },
    {
        "id": "item_4",
        "title": "Swiss Chronometer Pocket Watch",
        "category": "Horology",
        "price": 1650.0,
        "estimatedValueMin": 1500.0,
        "estimatedValueMax": 2000.0,
        "authenticityScore": 98,
        "era": "Art Deco (c. 1925)",
        "condition": "Fully Serviced & Working",
        "views": 320,
        "status": "Live",
        "sellerId": "dealer_geneva_watches",
        "sellerName": "Geneva Vintage Timepieces",
        "sellerRating": 5.0,
        "imageUrl": "assets/images/home_product_five.png",
        "images": ["assets/images/home_product_five.png"],
        "description": "18k solid gold open-face pocket watch with enamel dial, blued steel Breguet hands, and 17-jewel adjusted movement.",
        "materials": ["18k Solid Gold", "Enamel Dial", "Mineral Crystal"],
        "provenance": "Swiss Private Horological Guild",
        "dimensions": "48mm Case Diameter",
        "createdAt": datetime.now().isoformat()
    },
    {
        "id": "item_5",
        "title": "Art Nouveau Amber & Silver Brooch",
        "category": "Jewelry",
        "price": 480.0,
        "estimatedValueMin": 450.0,
        "estimatedValueMax": 650.0,
        "authenticityScore": 93,
        "era": "Art Nouveau (c. 1905)",
        "condition": "Excellent",
        "views": 75,
        "status": "Live",
        "sellerId": "dealer_gem_vault",
        "sellerName": "The Heirloom Vault",
        "sellerRating": 4.7,
        "imageUrl": "assets/images/home_product_two.png",
        "images": ["assets/images/home_product_two.png"],
        "description": "Natural Baltic amber cabochon set in flowing silver filigree vines. Hallmarked .925 sterling silver.",
        "materials": ["Sterling Silver 925", "Natural Baltic Amber"],
        "provenance": "Danish Family Heirloom",
        "dimensions": "5.5cm x 3.8cm",
        "createdAt": datetime.now().isoformat()
    }
]

def seed_marketplace_if_empty(db):
    """Seed Firestore marketplace_items collection if empty."""
    try:
        col = db.collection("marketplace_items")
        existing = list(col.limit(1).stream())
        if not existing:
            for item in DEFAULT_MARKETPLACE_ITEMS:
                col.document(item["id"]).set(item)
    except Exception as e:
        print(f"Failed to seed marketplace items: {e}")

# ==================== ENDPOINTS ====================

@router.get("/items")
def get_marketplace_items(
    category: Optional[str] = None,
    search: Optional[str] = None,
    status: Optional[str] = "Live",
    min_price: Optional[float] = None,
    max_price: Optional[float] = None,
    seller_id: Optional[str] = None
):
    """Returns list of marketplace items with optional filtering."""
    db = firestore.client()
    seed_marketplace_if_empty(db)
    
    query = db.collection("marketplace_items")
    if status and status != "All":
        query = query.where("status", "==", status)
    if category and category not in ["All Items", "All", ""]:
        query = query.where("category", "==", category)
    if seller_id:
        query = query.where("sellerId", "==", seller_id)
        
    docs = query.stream()
    items = []
    
    for doc in docs:
        data = doc.to_dict()
        data["id"] = doc.id
        
        # Apply client-like search filter
        if search:
            s = search.lower()
            title = data.get("title", "").lower()
            desc = data.get("description", "").lower()
            cat = data.get("category", "").lower()
            if s not in title and s not in desc and s not in cat:
                continue
                
        # Price filtering
        price = data.get("price", 0.0)
        if min_price is not None and price < min_price:
            continue
        if max_price is not None and price > max_price:
            continue
            
        items.append(data)
        
    return {"items": items, "count": len(items)}

@router.get("/items/{item_id}")
def get_item_detail(item_id: str):
    """Returns single item details."""
    db = firestore.client()
    doc = db.collection("marketplace_items").document(item_id).get()
    if not doc.exists:
        # Check in my_finds as fallback
        find_doc = db.collection("my_finds").document(item_id).get()
        if find_doc.exists:
            data = find_doc.to_dict()
            data["id"] = find_doc.id
            return data
        raise HTTPException(status_code=404, detail="Item not found")
        
    data = doc.to_dict()
    data["id"] = doc.id
    
    # Increment view count
    try:
        db.collection("marketplace_items").document(item_id).update({
            "views": firestore.Increment(1)
        })
    except Exception:
        pass
        
    return data

@router.post("/items")
def create_marketplace_item(item: ItemCreateRequest, user_id: str = Depends(get_current_user_id)):
    """Creates a new item directly in the marketplace."""
    db = firestore.client()
    item_id = f"item_{uuid.uuid4().hex[:8]}"
    item_dict = item.model_dump()
    item_dict["id"] = item_id
    item_dict["createdAt"] = datetime.now().isoformat()
    item_dict["views"] = 0
    if not item_dict.get("sellerId"):
        item_dict["sellerId"] = user_id
    
    db.collection("marketplace_items").document(item_id).set(item_dict)
    return {"status": "created", "item": item_dict}

# ==================== AI SCAN & MY FINDS ====================

@router.post("/scans/analyze")
def analyze_scan(scan_data: ScanRequest):
    """Simulates AI appraisal analysis for scanned / uploaded antique pictures."""
    # Deterministic / intelligent response based on hint
    hint = (scan_data.categoryHint or "Furniture").lower()
    
    if "watch" in hint or "horology" in hint or "clock" in hint:
        return {
            "title": "Swiss Chronometer Pocket Watch",
            "category": "Horology",
            "estimatedValue": {"min": 1400.0, "max": 1950.0, "currency": "USD"},
            "authenticityScore": 95,
            "era": "Art Deco (c. 1920-1935)",
            "condition": "Excellent - Mechanical Integrity Intact",
            "materials": ["18k Gold Plated Brass", "Enamel Dial", "Jeweled Movement"],
            "provenance": "Swiss Jura Region Horological Master",
            "dimensions": "48mm Diameter",
            "keyCharacteristics": [
                "Intricate guilloché pattern on caseback",
                "Roman numeral porcelain dial with sub-seconds dial",
                "High beat lever escapement mechanism"
            ],
            "estimatedMarketDemand": "High (Watch Collectors Market)"
        }
    elif "pottery" in hint or "vase" in hint or "ceramic" in hint:
        return {
            "title": "Ming-Style Cobalt Porcelain Vase",
            "category": "Pottery",
            "estimatedValue": {"min": 850.0, "max": 1400.0, "currency": "USD"},
            "authenticityScore": 92,
            "era": "Late Qing Dynasty (c. 1890)",
            "condition": "Mint - No chips or hairline cracks",
            "materials": ["Kaolin Clay", "Cobalt Oxide Glaze"],
            "provenance": "Jingdezhen Kilns, China",
            "dimensions": "32cm H x 16cm W",
            "keyCharacteristics": [
                "Hand-painted dragon and wave motif",
                "Authentic double-ring kiln seal on base",
                "Even crackle patina glaze"
            ],
            "estimatedMarketDemand": "Very High"
        }
    else:
        return {
            "title": "Victorian Mahogany Armchair",
            "category": "Furniture",
            "estimatedValue": {"min": 1200.0, "max": 1800.0, "currency": "USD"},
            "authenticityScore": 94,
            "era": "Late Victorian (c. 1880-1900)",
            "condition": "Excellent - Original Patina",
            "materials": ["Solid Honduran Mahogany", "Brass Joinery", "Silk Damask"],
            "provenance": "English Victorian Estate",
            "dimensions": "96cm H x 65cm W x 70cm D",
            "keyCharacteristics": [
                "Hand-carved lion paw feet",
                "Tenon and mortise joinery with timber pegging",
                "Archival floral damask upholstery"
            ],
            "estimatedMarketDemand": "Moderate to High"
        }

@router.get("/my-finds")
def get_my_finds(user_id: str = Depends(get_current_user_id), category: Optional[str] = None):
    """Lists all scanned items saved in user's 'My Finds' collection."""
    db = firestore.client()
    query = db.collection("my_finds").where("userId", "==", user_id)
    
    docs = list(query.stream())
    
    # If no items found for this user, seed some initial finds
    if not docs:
        initial_finds = [
            {
                "id": f"find_{uuid.uuid4().hex[:8]}",
                "userId": user_id,
                "title": "Victorian Mahogany Chair",
                "category": "Furniture",
                "price": "$1,200 - $1,800",
                "estimatedPriceMin": 1200.0,
                "estimatedPriceMax": 1800.0,
                "authenticityScore": 94,
                "views": 124,
                "status": "Live",
                "image": "assets/images/home_product_one.png",
                "era": "Victorian (c. 1880)",
                "condition": "Excellent",
                "createdAt": datetime.now().isoformat()
            },
            {
                "id": f"find_{uuid.uuid4().hex[:8]}",
                "userId": user_id,
                "title": "Antique Oak Cabinet",
                "category": "Furniture",
                "price": "$1,200 - $1,800",
                "estimatedPriceMin": 1200.0,
                "estimatedPriceMax": 1800.0,
                "authenticityScore": 91,
                "views": 89,
                "status": "Live",
                "image": "assets/images/home_product_four.png",
                "era": "Edwardian (c. 1910)",
                "condition": "Very Good",
                "createdAt": datetime.now().isoformat()
            },
            {
                "id": f"find_{uuid.uuid4().hex[:8]}",
                "userId": user_id,
                "title": "Porcelain Vase Collection",
                "category": "Pottery",
                "price": "$800 - $1,200",
                "estimatedPriceMin": 800.0,
                "estimatedPriceMax": 1200.0,
                "authenticityScore": 96,
                "views": 156,
                "status": "Sold",
                "image": "assets/images/home_product_three.png",
                "era": "Qing Dynasty (c. 1890)",
                "condition": "Mint",
                "createdAt": datetime.now().isoformat()
            },
            {
                "id": f"find_{uuid.uuid4().hex[:8]}",
                "userId": user_id,
                "title": "Vintage Pocket Watch",
                "category": "Horology",
                "price": "$1,500 - $2,000",
                "estimatedPriceMin": 1500.0,
                "estimatedPriceMax": 2000.0,
                "authenticityScore": 98,
                "views": 0,
                "status": "Draft",
                "image": "assets/images/home_product_five.png",
                "era": "Art Deco (c. 1925)",
                "condition": "Working",
                "createdAt": datetime.now().isoformat()
            }
        ]
        for find in initial_finds:
            db.collection("my_finds").document(find["id"]).set(find)
        docs = list(db.collection("my_finds").where("userId", "==", user_id).stream())
        
    finds = []
    for doc in docs:
        data = doc.to_dict()
        data["id"] = doc.id
        if category and category not in ["All Items", "All", ""] and data.get("category") != category:
            continue
        finds.append(data)
        
    return {"finds": finds, "count": len(finds)}

@router.post("/my-finds")
def save_to_my_finds(find: SaveFindRequest, user_id: str = Depends(get_current_user_id)):
    """Saves a scanned item to the user's My Finds collection."""
    db = firestore.client()
    find_id = f"find_{uuid.uuid4().hex[:8]}"
    data = find.model_dump()
    data["id"] = find_id
    data["userId"] = user_id
    data["price"] = f"${int(find.estimatedPriceMin):,} - ${int(find.estimatedPriceMax):,}"
    data["views"] = 0
    data["status"] = "Draft"
    data["createdAt"] = datetime.now().isoformat()
    if not data.get("imageUrl"):
        data["imageUrl"] = "assets/images/home_product_one.png"
    data["image"] = data["imageUrl"]
    
    db.collection("my_finds").document(find_id).set(data)
    return {"status": "saved", "find": data}

@router.post("/my-finds/{find_id}/list")
def list_find_to_marketplace(
    find_id: str,
    list_price: float = Query(..., description="Selling price for the marketplace listing"),
    user_id: str = Depends(get_current_user_id)
):
    """Converts an item from My Finds into a live Marketplace item."""
    db = firestore.client()
    find_ref = db.collection("my_finds").document(find_id)
    find_doc = find_ref.get()
    
    if not find_doc.exists:
        raise HTTPException(status_code=404, detail="Find not found")
        
    find_data = find_doc.to_dict()
    
    # Update find status to Live
    find_ref.update({"status": "Live", "price": f"${int(list_price):,}"})
    
    # Create Marketplace Item
    market_item_id = f"item_{find_id.replace('find_', '')}"
    market_data = {
        "id": market_item_id,
        "title": find_data.get("title", "Vintage Item"),
        "category": find_data.get("category", "Furniture"),
        "price": list_price,
        "estimatedValueMin": find_data.get("estimatedPriceMin", list_price * 0.8),
        "estimatedValueMax": find_data.get("estimatedPriceMax", list_price * 1.2),
        "authenticityScore": find_data.get("authenticityScore", 90),
        "era": find_data.get("era", "Antique"),
        "condition": find_data.get("condition", "Good"),
        "views": 0,
        "status": "Live",
        "sellerId": user_id,
        "sellerName": "Verified Collector",
        "sellerRating": 5.0,
        "imageUrl": find_data.get("imageUrl") or find_data.get("image") or "assets/images/home_product_one.png",
        "images": [find_data.get("imageUrl") or find_data.get("image") or "assets/images/home_product_one.png"],
        "description": find_data.get("notes") or f"Authenticated {find_data.get('era', '')} {find_data.get('title', '')}.",
        "materials": find_data.get("materials", []),
        "provenance": find_data.get("provenance", "Private Collection"),
        "createdAt": datetime.now().isoformat()
    }
    
    db.collection("marketplace_items").document(market_item_id).set(market_data)
    return {"status": "listed", "marketplaceItem": market_data}
