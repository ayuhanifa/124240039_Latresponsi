class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String gender;
  final String origin;
  final String location;
  final String image;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.origin,
    required this.location,
    required this.image,
  });

  factory Character.fromJson(Map<String, dynamic> jsonData) {
    return Character(
      id: jsonData['id'],
      name: jsonData['name'] ?? '',
      status: jsonData['status'] ?? '',
      species: jsonData['species'] ?? '',
      gender: jsonData['gender'] ?? '',
      origin: jsonData['origin']?['name'] ?? '',
      location: jsonData['location']?['name'] ?? '',
      image: jsonData['image'] ?? '',
    );
  }

  // Bentuknya dibuat sama dengan response API,
  // jadi data favorite yang disimpan bisa dibaca lagi lewat fromJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'gender': gender,
      'origin': {'name': origin},
      'location': {'name': location},
      'image': image,
    };
  }
}

class CharacterPage {
  final List<Character> characters;
  final bool hasNext;

  CharacterPage({required this.characters, required this.hasNext});
}
