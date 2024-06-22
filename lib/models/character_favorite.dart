class CharacterFavorite {
  final int id;
  final String name;
  final String status;
  final String species;
  final String image;

  CharacterFavorite({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.image
  });

  CharacterFavorite.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        status = map['status'], 
        species = map['species'],
        image = map['image']; 
  
}