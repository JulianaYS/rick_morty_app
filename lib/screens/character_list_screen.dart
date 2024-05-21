import 'package:flutter/material.dart';
import 'package:rick_morty_app/models/character.dart';
import 'package:rick_morty_app/services/character_service.dart';

class CharacterListScreen extends StatelessWidget{

  const CharacterListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Rick & Morty'),
      ),
      body: CharacterList(),
    );
  }
}

class CharacterList extends StatefulWidget {
  const CharacterList({super.key});

  @override
  State<CharacterList> createState() => _CharacterListState();
}

class _CharacterListState extends State<CharacterList> {
  List _characters = [];
  //listagenerica que puede tener cualquier tipo de dato
  //_ private
  final CharacterService _characterService = CharacterService();

  initialize() async {
    _characters = await _characterService.getAll();
    setState(() {
      _characters = _characters;
    });
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: _characters.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0
        ), 
      itemBuilder: (context, index) {
        return CharacterItem(character: _characters[index]);
      },
    );
  }
}

class CharacterItem extends StatelessWidget {
  final Character character;
  //dynamic
  const CharacterItem({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(character.image),
          Text(character.name),
          Text(character.status),
          Text(character.species),
          Text(character.gender),
        ]
      )
    );
  }
}