import 'package:flutter/material.dart';
import 'package:rick_morty_app/models/character.dart';

class CharacterDetailsScreen extends StatelessWidget {
  final Character character;

  const CharacterDetailsScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = (character.status == "Alive")? Colors.green:Colors.red;
    return Scaffold(
      backgroundColor: backgroundColor ,
      appBar: AppBar(
        title: Text(character.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: backgroundColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              character.image,
              width: MediaQuery.of(context).size.width, 
              fit: BoxFit.cover, 
            ),
            //Image.network(character.image, width: 800),
            Text(character.name, style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
            Text(character.species, style: const TextStyle(fontSize: 24)),
           
          ],
        ),
      ),
    );
  }
}