class CharacterModel {
  final int id;
  final String name;
  final String imageUrl;
  final double price;
  final bool isPremium;
  final bool isOwned;
  final String? description;

  const CharacterModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.isPremium,
    required this.isOwned,
    this.description,
  });
}

