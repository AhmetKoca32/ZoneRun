import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../../core/services/firebase_service.dart';
import '../../../../core/services/purchase_service.dart';
import '../../data/models/character_model.dart';
import '../../data/services/firestore_user_service.dart';

class StoreProvider extends ChangeNotifier {
  final FirestoreUserService _firestoreUserService = FirestoreUserService();
  final PurchaseService _purchaseService = PurchaseService();
  List<CharacterModel> _characters = [];
  bool _isLoading = true;
  List<int> _purchasedCharacterIds = [];
  bool _isPurchaseAvailable = false;
  bool _isPurchasing = false;
  int? _purchasingCharacterId;
  String? _purchaseError;
  
  bool get isPurchaseAvailable => _isPurchaseAvailable;
  bool get isPurchasing => _isPurchasing;
  int? get purchasingCharacterId => _purchasingCharacterId;
  String? get purchaseError => _purchaseError;

  List<CharacterModel> get characters => _characters;
  bool get isLoading => _isLoading;
  CharacterModel? get featuredCharacter => _characters.isNotEmpty
      ? _characters.firstWhere(
          (char) => char.isPremium,
          orElse: () => _characters.first,
        )
      : null;

  StoreProvider() {
    _initializePurchaseService();
    // Load purchased characters first, then load characters
    // This ensures ownership is set correctly based on Firestore data
    _loadPurchasedCharacters().then((_) {
      _loadCharacters();
    });
  }
  
  Future<void> _initializePurchaseService() async {
    _isPurchaseAvailable = await _purchaseService.isAvailable();
    if (_isPurchaseAvailable) {
      // Listen to purchase updates
      _purchaseService.purchaseStream.listen(
        (purchases) {
          for (final purchase in purchases) {
            _handlePurchaseUpdate(purchase);
          }
        },
      );
    }
  }
  
  Future<void> _handlePurchaseUpdate(PurchaseDetails purchase) async {
    if (purchase.status == PurchaseStatus.purchased) {
      try {
        // Validate purchase receipt
        final isValid = await _purchaseService.validatePurchase(purchase);
        if (isValid) {
          // Extract character ID from product ID
          // Product ID format: "character_1", "character_2", etc.
          final productId = purchase.productID;
          if (productId.startsWith('character_')) {
            final characterId = int.tryParse(productId.replaceFirst('character_', ''));
            if (characterId != null) {
              // Complete purchase directly (already validated)
              await _completePurchaseDirectly(characterId);
            }
          } else if (productId == 'premium_membership') {
            // Handle premium membership purchase
            // This would be handled by ProfileProvider
          }
          
          // Complete the purchase
          await _purchaseService.completePurchase(purchase);
        } else {
          _purchaseError = 'Satın alma doğrulaması başarısız';
          _isPurchasing = false;
          _purchasingCharacterId = null;
          notifyListeners();
        }
      } catch (e) {
        _purchaseError = 'Satın alma işlenirken hata oluştu: ${e.toString()}';
        _isPurchasing = false;
        _purchasingCharacterId = null;
        notifyListeners();
      }
    } else if (purchase.status == PurchaseStatus.error) {
      _purchaseError = purchase.error?.message ?? 'Satın alma hatası';
      _isPurchasing = false;
      _purchasingCharacterId = null;
      notifyListeners();
      if (kDebugMode) {
        print('Purchase error: ${purchase.error}');
      }
    } else if (purchase.status == PurchaseStatus.canceled) {
      _purchaseError = null;
      _isPurchasing = false;
      _purchasingCharacterId = null;
      notifyListeners();
    }
  }

  void clearPurchaseError() {
    _purchaseError = null;
    notifyListeners();
  }
  
  Future<void> _loadPurchasedCharacters() async {
    try {
      final profile = await _firestoreUserService.getUserProfile();
      if (profile != null) {
        _purchasedCharacterIds = profile.purchasedCharacters;
        if (kDebugMode) {
          print('📦 Loaded purchased characters from Firestore: $_purchasedCharacterIds');
        }
        // Update ownership if characters are already loaded
        if (_characters.isNotEmpty) {
          _updateCharacterOwnership();
        }
      } else {
        if (kDebugMode) {
          print('⚠️ No user profile found, starting with empty purchased characters');
        }
        _purchasedCharacterIds = [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading purchased characters: $e');
      }
      _purchasedCharacterIds = [];
    }
  }
  
  void _updateCharacterOwnership() {
    if (kDebugMode) {
      print('🔄 Updating character ownership. Purchased IDs: $_purchasedCharacterIds');
    }
    for (var i = 0; i < _characters.length; i++) {
      final character = _characters[i];
      final isOwned = _purchasedCharacterIds.contains(character.id) || 
                      !character.isPremium; // Free characters are always owned
      if (kDebugMode && character.isOwned != isOwned) {
        print('  Character ${character.id} (${character.name}): ${character.isOwned} -> $isOwned (Premium: ${character.isPremium}, In purchased list: ${_purchasedCharacterIds.contains(character.id)})');
      }
      if (character.isOwned != isOwned) {
        _characters[i] = CharacterModel(
          id: character.id,
          name: character.name,
          imageUrl: character.imageUrl,
          price: character.price,
          isPremium: character.isPremium,
          isOwned: isOwned,
          description: character.description,
        );
      }
    }
    notifyListeners();
  }

  Future<void> _loadCharacters() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Mock data
      await Future.delayed(const Duration(milliseconds: 500));

      _characters = [
        const CharacterModel(
          id: 1,
          name: 'Karakter 1',
          imageUrl: '',
          price: 0.0,
          isPremium: false,
          isOwned: false, // Will be set to true by _updateCharacterOwnership (free characters)
        ),
        const CharacterModel(
          id: 2,
          name: 'Karakter 2',
          imageUrl: '',
          price: 50.0,
          isPremium: true,
          isOwned: false, // Will be set based on Firestore purchasedCharacters
        ),
        const CharacterModel(
          id: 3,
          name: 'Karakter 3',
          imageUrl: '',
          price: 75.0,
          isPremium: true,
          isOwned: false,
        ),
        const CharacterModel(
          id: 4,
          name: 'Karakter 4',
          imageUrl: '',
          price: 100.0,
          isPremium: true,
          isOwned: false,
        ),
        const CharacterModel(
          id: 5,
          name: 'Karakter 5',
          imageUrl: '',
          price: 0.0,
          isPremium: false,
          isOwned: false, // Will be set to true by _updateCharacterOwnership (free characters)
        ),
        const CharacterModel(
          id: 6,
          name: 'Premium Pack',
          imageUrl: '',
          price: 299.0,
          isPremium: true,
          isOwned: false,
          description: 'Tüm premium karakterleri içerir',
        ),
      ];
      
      // Update ownership based on purchased characters from Firestore
      // This will set isOwned correctly based on _purchasedCharacterIds
      _updateCharacterOwnership();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading characters: $e');
      }
      _characters = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> purchaseCharacter(int characterId) async {
    if (_isPurchasing) {
      return false; // Already processing a purchase
    }

    try {
      _isPurchasing = true;
      _purchasingCharacterId = characterId;
      _purchaseError = null;
      notifyListeners();

      final character = _characters.firstWhere((char) => char.id == characterId);
      
      // If already owned, return success
      if (character.isOwned) {
        _isPurchasing = false;
        _purchasingCharacterId = null;
        notifyListeners();
        return true;
      }

      // If purchase service is available, use in-app purchase
      if (_isPurchaseAvailable && character.isPremium) {
        // Get product ID (format: "character_1", "character_2", etc.)
        final productId = 'character_$characterId';
        final products = await _purchaseService.getProducts({productId});
        
        if (products.isEmpty) {
          // Product not found in store - use fallback with Firebase Functions for testing
          if (kDebugMode) {
            print('⚠️ Product not found in store, using fallback with Firebase Functions for testing');
          }
          await _completePurchaseWithValidation(characterId, productId);
          return true;
        }
        
        // Initiate purchase flow
        final success = await _purchaseService.purchaseProduct(products.first);
        if (!success) {
          throw Exception('Satın alma başlatılamadı');
        }
        // Purchase will be handled by _handlePurchaseUpdate
        // Don't reset _isPurchasing here - it will be reset in _handlePurchaseUpdate
        return true;
      }
      
      // Fallback: Direct purchase (for free characters or testing)
      if (character.isPremium) {
        // Premium character but IAP not available - use Firebase Functions for validation
        final productId = 'character_$characterId';
        await _completePurchaseWithValidation(characterId, productId);
      } else {
        // Free character - direct purchase
        await _completePurchaseDirectly(characterId);
      }
      return true;
    } catch (e) {
      _purchaseError = e.toString().replaceFirst('Exception: ', '');
      _isPurchasing = false;
      _purchasingCharacterId = null;
      notifyListeners();
      if (kDebugMode) {
        print('Error purchasing character: $e');
      }
      return false;
    }
  }

  /// Complete purchase directly (for free characters)
  Future<void> _completePurchaseDirectly(int characterId) async {
    // Add to Firestore
    await _firestoreUserService.addPurchasedCharacter(characterId);
    
    // Update local state
    _purchasedCharacterIds.add(characterId);
    final index = _characters.indexWhere((char) => char.id == characterId);
    if (index != -1) {
      _characters[index] = CharacterModel(
        id: _characters[index].id,
        name: _characters[index].name,
        imageUrl: _characters[index].imageUrl,
        price: _characters[index].price,
        isPremium: _characters[index].isPremium,
        isOwned: true,
        description: _characters[index].description,
      );
    }
    
    _isPurchasing = false;
    _purchasingCharacterId = null;
    notifyListeners();
  }

  /// Complete purchase with Firebase Functions validation (for testing premium characters)
  Future<void> _completePurchaseWithValidation(int characterId, String productId) async {
    try {
      // Check if user is authenticated
      final currentUser = FirebaseService.currentUser;
      if (currentUser == null) {
        if (kDebugMode) {
          print('⚠️ User not authenticated, using direct purchase');
        }
        await _completePurchaseDirectly(characterId);
        return;
      }

      if (kDebugMode) {
        print('🔐 Calling Firebase Functions for purchase validation: $productId');
        print('   User ID: ${currentUser.uid}');
      }

      // Call Firebase Function directly for testing
      // Use the same instance that was configured in main.dart
      final callable = FirebaseFunctions.instance.httpsCallable('validateGooglePlayPurchase');
      
      // Create a test purchase token for testing
      final testPurchaseToken = 'test_token_${DateTime.now().millisecondsSinceEpoch}';
      
      if (kDebugMode) {
        print('📞 Calling Firebase Function with:');
        print('   productId: $productId');
        print('   purchaseToken: $testPurchaseToken');
        print('   packageName: com.example.zone_run');
        print('   Function URL: validateGooglePlayPurchase');
      }
      
      // Add timeout and better error handling
      final result = await callable.call({
        'productId': productId,
        'purchaseToken': testPurchaseToken,
        'packageName': 'com.example.zone_run',
      }).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          if (kDebugMode) {
            print('⏱️ Firebase Function call timed out after 10 seconds');
            print('   This usually means the emulator is not reachable');
            print('   Check: Is emulator running? Is port 5001 accessible?');
          }
          throw Exception('Function call timed out - emulator may not be reachable');
        },
      );

      if (result.data['success'] == true) {
        if (kDebugMode) {
          print('✅ Purchase validated by Firebase Functions: $productId');
          print('   Character ID: ${result.data['characterId']}');
        }
        
        // Firebase Function already added to Firestore, just update local state
        _purchasedCharacterIds.add(characterId);
        final index = _characters.indexWhere((char) => char.id == characterId);
        if (index != -1) {
          _characters[index] = CharacterModel(
            id: _characters[index].id,
            name: _characters[index].name,
            imageUrl: _characters[index].imageUrl,
            price: _characters[index].price,
            isPremium: _characters[index].isPremium,
            isOwned: true,
            description: _characters[index].description,
          );
        }
        
        _isPurchasing = false;
        _purchasingCharacterId = null;
        notifyListeners();
      } else {
        throw Exception('Firebase Functions validation failed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Firebase Functions validation error: $e');
        print('   Falling back to direct purchase');
      }
      // Fallback to direct purchase if Functions fails
      await _completePurchaseDirectly(characterId);
    }
  }
  
  /// Restore purchases
  Future<void> restorePurchases() async {
    if (!_isPurchaseAvailable) return;
    
    try {
      await _purchaseService.restorePurchases();
    } catch (e) {
      if (kDebugMode) {
        print('Error restoring purchases: $e');
      }
    }
  }

  String formatPrice(double price) {
    if (price == 0) return 'Ücretsiz';
    return '₺${price.toStringAsFixed(0)}';
  }
}
