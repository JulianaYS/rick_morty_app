class Character{
  final int id;
  final String name;
  final String status;
  final String species;
  final String gender;
  final String image;

  const Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.image
  });

  //cuando no esta definido -> dynamic
  Character.fromJson(Map<String, dynamic> map)
  : id = map['id'], 
    name = map['name'], 
    status = map['status'], 
    species = map['species'], 
    gender = map['gender'], 
    image = map['image']; 
  //esto nos sirve para traer la data de un objeto tipo map
}
