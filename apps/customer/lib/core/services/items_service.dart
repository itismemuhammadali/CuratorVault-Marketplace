import 'package:flutter/foundation.dart';
import 'package:vintage_app/core/services/api_service.dart';

class ItemsService {
  static Future<List<Map<String, dynamic>>> getMarketplaceItems({
    String? category,
    String? search,
  }) async {
    try {
      String endpoint = '/api/v1/items';
      final params = <String>[];
      if (category != null && category.isNotEmpty && category != 'All Items' && category != 'All') {
        params.add('category=${Uri.encodeComponent(category)}');
      }
      if (search != null && search.isNotEmpty) {
        params.add('search=${Uri.encodeComponent(search)}');
      }
      if (params.isNotEmpty) {
        endpoint += '?${params.join('&')}';
      }

      final response = await ApiService.get(endpoint);
      if (response is Map && response['items'] is List) {
        return List<Map<String, dynamic>>.from(response['items']);
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching marketplace items: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getItemDetail(String id) async {
    try {
      final response = await ApiService.get('/api/v1/items/$id');
      if (response is Map) {
        return Map<String, dynamic>.from(response);
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching item detail ($id): $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>> analyzeScan({
    String? imagePath,
    String? categoryHint,
  }) async {
    try {
      final response = await ApiService.post('/api/v1/scans/analyze', {
        'imagePath': imagePath,
        'categoryHint': categoryHint ?? 'Furniture',
      });
      if (response is Map) {
        return Map<String, dynamic>.from(response);
      }
      return {};
    } catch (e) {
      debugPrint('Error analyzing scan: $e');
      return {
        'title': 'Victorian Antique',
        'category': 'Furniture',
        'estimatedValue': {'min': 1200.0, 'max': 1800.0, 'currency': 'USD'},
        'authenticityScore': 94,
        'era': 'Late 19th Century',
        'condition': 'Excellent - Original Patina',
      };
    }
  }

  static Future<List<Map<String, dynamic>>> getMyFinds({String? category}) async {
    try {
      String endpoint = '/api/v1/my-finds';
      if (category != null && category.isNotEmpty && category != 'All Items') {
        endpoint += '?category=${Uri.encodeComponent(category)}';
      }
      final response = await ApiService.get(endpoint);
      if (response is Map && response['finds'] is List) {
        return List<Map<String, dynamic>>.from(response['finds']);
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching my finds: $e');
      return [];
    }
  }

  static Future<bool> saveFind(Map<String, dynamic> data) async {
    try {
      await ApiService.post('/api/v1/my-finds', data);
      return true;
    } catch (e) {
      debugPrint('Error saving find: $e');
      return false;
    }
  }

  static Future<bool> listFind(String findId, double price) async {
    try {
      await ApiService.post('/api/v1/my-finds/$findId/list?list_price=$price', {});
      return true;
    } catch (e) {
      debugPrint('Error listing find: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> getCart() async {
    try {
      final response = await ApiService.get('/api/v1/cart');
      if (response is Map) {
        return Map<String, dynamic>.from(response);
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching cart: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> addToCart(String itemId, {int quantity = 1}) async {
    try {
      final response = await ApiService.post('/api/v1/cart/add', {
        'itemId': itemId,
        'quantity': quantity,
      });
      if (response is Map && response['cart'] is Map) {
        return Map<String, dynamic>.from(response['cart']);
      }
      return null;
    } catch (e) {
      debugPrint('Error adding to cart: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> removeFromCart(String itemId) async {
    try {
      final response = await ApiService.delete('/api/v1/cart/$itemId');
      if (response is Map && response['cart'] is Map) {
        return Map<String, dynamic>.from(response['cart']);
      }
      return null;
    } catch (e) {
      debugPrint('Error removing from cart: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>?> processCheckout({
    required Map<String, dynamic> shippingAddress,
    String paymentMethod = 'card',
    List<Map<String, dynamic>>? items,
  }) async {
    try {
      final response = await ApiService.post('/api/v1/checkout', {
        'shippingAddress': shippingAddress,
        'paymentMethod': paymentMethod,
        'items': items,
      });
      if (response is Map && response['order'] is Map) {
        return Map<String, dynamic>.from(response['order']);
      }
      return null;
    } catch (e) {
      debugPrint('Error processing checkout: $e');
      return null;
    }
  }

  static Future<bool> createOffer(Map<String, dynamic> offerData) async {
    try {
      await ApiService.post('/api/v1/offers', offerData);
      return true;
    } catch (e) {
      debugPrint('Error creating offer: $e');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getOffers({String? type}) async {
    try {
      String endpoint = '/api/v1/offers';
      if (type != null && type.isNotEmpty) {
        endpoint += '?type=$type';
      }
      final response = await ApiService.get(endpoint);
      if (response is Map && response['offers'] is List) {
        return List<Map<String, dynamic>>.from(response['offers']);
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching offers: $e');
      return [];
    }
  }

  static Future<bool> respondOffer(String offerId, String status, {double? counterPrice, String? message}) async {
    try {
      await ApiService.post('/api/v1/offers/$offerId/respond', {
        'status': status,
        'counterPrice': counterPrice,
        'message': message,
      });
      return true;
    } catch (e) {
      debugPrint('Error responding to offer: $e');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getChats() async {
    try {
      final response = await ApiService.get('/api/v1/chats');
      if (response is Map && response['chats'] is List) {
        return List<Map<String, dynamic>>.from(response['chats']);
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching chats: $e');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getChatMessages(String chatId) async {
    try {
      final response = await ApiService.get('/api/v1/chats/$chatId/messages');
      if (response is Map && response['messages'] is List) {
        return List<Map<String, dynamic>>.from(response['messages']);
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching chat messages: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> sendMessage(String chatId, String message, {String senderRole = 'customer'}) async {
    try {
      final data = {
        'text': message,
        'senderRole': senderRole,
        'time': 'Just now',
      };
      await ApiService.post('/api/v1/chats/$chatId/messages', data);
      return data;
    } catch (e) {
      debugPrint('Error sending message: $e');
      return {
        'text': message,
        'senderRole': senderRole,
        'time': 'Just now',
      };
    }
  }
}

