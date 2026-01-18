import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:cloud_functions/cloud_functions.dart';

/// Service for handling in-app purchases and receipt validation
class PurchaseService {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;
  
  /// Get Firebase Functions instance (for direct calls)
  FirebaseFunctions get functions => _functions;
  
  /// Check if in-app purchases are available
  Future<bool> isAvailable() async {
    return await _inAppPurchase.isAvailable();
  }
  
  /// Get available products
  Future<List<ProductDetails>> getProducts(Set<String> productIds) async {
    final response = await _inAppPurchase.queryProductDetails(productIds);
    if (response.error != null) {
      if (kDebugMode) {
        print('Error querying products: ${response.error}');
      }
      return [];
    }
    return response.productDetails;
  }
  
  /// Purchase a product
  Future<bool> purchaseProduct(ProductDetails productDetails) async {
    try {
      final purchaseParam = PurchaseParam(
        productDetails: productDetails,
      );
      return await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      if (kDebugMode) {
        print('Error purchasing product: $e');
      }
      return false;
    }
  }
  
  /// Restore purchases
  Future<void> restorePurchases() async {
    try {
      await _inAppPurchase.restorePurchases();
    } catch (e) {
      if (kDebugMode) {
        print('Error restoring purchases: $e');
      }
    }
  }
  
  /// Purchase stream - listen to purchase updates
  Stream<List<PurchaseDetails>> get purchaseStream => _inAppPurchase.purchaseStream;
  
  /// Validate purchase receipt with backend (Google Play/App Store)
  Future<bool> validatePurchase(PurchaseDetails purchase) async {
    if (purchase.status != PurchaseStatus.purchased) {
      return false;
    }

    try {
      if (Platform.isAndroid) {
        return await _validateGooglePlayPurchase(purchase);
      } else if (Platform.isIOS) {
        return await _validateAppStorePurchase(purchase);
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error validating purchase: $e');
      }
      return false;
    }
  }

  /// Validate Google Play purchase via Firebase Functions
  Future<bool> _validateGooglePlayPurchase(PurchaseDetails purchase) async {
    try {
      // Android purchase details - verificationData içinde purchaseToken var
      final verificationData = purchase.verificationData;
      
      if (verificationData.serverVerificationData.isEmpty) {
        if (kDebugMode) {
          print('No server verification data found for Android purchase');
        }
        return false;
      }

      // Package name - Android'de genellikle uygulama package name'i
      // Bu bilgiyi main.dart veya config'den alabilirsin
      const packageName = 'com.example.zone_run'; // TODO: Config'den al

      // Call Firebase Function
      final callable = _functions.httpsCallable('validateGooglePlayPurchase');
      final result = await callable.call({
        'productId': purchase.productID,
        'purchaseToken': verificationData.serverVerificationData,
        'packageName': packageName,
      });

      if (result.data['success'] == true) {
        if (kDebugMode) {
          print('Purchase validated successfully: ${purchase.productID}');
        }
        return true;
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error validating Google Play purchase: $e');
      }
      return false;
    }
  }

  /// Validate App Store purchase via Firebase Functions
  Future<bool> _validateAppStorePurchase(PurchaseDetails purchase) async {
    try {
      // iOS purchase details - verificationData içinde receipt data var
      final verificationData = purchase.verificationData;
      
      if (verificationData.serverVerificationData.isEmpty) {
        if (kDebugMode) {
          print('No server verification data found for iOS purchase');
        }
        return false;
      }

      // Transaction ID - iOS'de transactionIdentifier kullanılır
      final transactionId = purchase.transactionDate ?? 
          DateTime.now().millisecondsSinceEpoch.toString();

      // Call Firebase Function
      final callable = _functions.httpsCallable('validateAppStorePurchase');
      final result = await callable.call({
        'productId': purchase.productID,
        'receiptData': verificationData.serverVerificationData,
        'transactionId': transactionId,
      });

      if (result.data['success'] == true) {
        if (kDebugMode) {
          print('Purchase validated successfully: ${purchase.productID}');
        }
        return true;
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print('Error validating App Store purchase: $e');
      }
      return false;
    }
  }
  
  /// Complete purchase
  Future<void> completePurchase(PurchaseDetails purchase) async {
    if (purchase.pendingCompletePurchase) {
      await _inAppPurchase.completePurchase(purchase);
    }
  }
}
