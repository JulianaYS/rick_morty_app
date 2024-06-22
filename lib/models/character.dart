
class Character{
  final int id;
  final String name;
  final String status;
  final String species;
  final String image;

  const Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.image
  });

  //cuando no esta definido -> dynamic
  Character.fromJson(Map<String, dynamic> map)
  : id = map['id'], 
    name = map['name'], 
    status = map['status'], 
    species = map['species'], 
    image = map['image']; 
  //esto nos sirve para traer la data de un objeto tipo map

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'image': image
    };
  }
}
