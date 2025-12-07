import 'package:flutter/foundation.dart';

import '../../data/models/character_model.dart';

class StoreProvider extends ChangeNotifier {
  List<CharacterModel> _characters = [];
  bool _isLoading = true;

  List<CharacterModel> get characters => _characters;
  bool get isLoading => _isLoading;
  CharacterModel? get featuredCharacter => _characters.isNotEmpty
      ? _characters.firstWhere(
          (char) => char.isPremium,
          orElse: () => _characters.first,
        )
      : null;

  StoreProvider() {
    _loadCharacters();
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
          isOwned: true,
        ),
        const CharacterModel(
          id: 2,
          name: 'Karakter 2',
          imageUrl: '',
          price: 50.0,
          isPremium: true,
          isOwned: true,
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
          isOwned: true,
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

  Future<void> purchaseCharacter(int characterId) async {
    // TODO: Implement purchase logic
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
      notifyListeners();
    }
  }

  String formatPrice(double price) {
    if (price == 0) return 'Ücretsiz';
    return '₺${price.toStringAsFixed(0)}';
  }
}

