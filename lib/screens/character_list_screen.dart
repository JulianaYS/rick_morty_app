import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
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
  //List _characters = [];
  //listagenerica que puede tener cualquier tipo de dato
  //_ private
  final CharacterService _characterService = CharacterService();

  static const _pageSize = 20; //# de elementos que se muestran por paginas

  final PagingController<int, Character> _pagingController = //q pagina se mostrara y q elementos
      PagingController(firstPageKey: 1); //inicializa en pagina 1

  //cada vez q detecta una nueva pagina invoca este metodo
  @override
  void initState() { //se invc cuando se crea el estado
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey); //_ privado
    });
    super.initState();
  }

  //trae la nueva pagina
  Future<void> _fetchPage(int pageKey) async { 
    try {
      final newItems = await _characterService.getAll(pageKey); //jala del api
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems as List<Character>); //se castea
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems as List<Character>, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PagedGridView<int, Character>(
      pagingController: _pagingController, 
      builderDelegate: PagedChildBuilderDelegate(
        itemBuilder: (context, item, index){
          return CharacterItem(character: item);
        }
      ), 
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
    ); 
  }

  //libera el espacio q usa el pagingcontroller
  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

class CharacterItem extends StatelessWidget {
  final Character character;
  //dynamic
  const CharacterItem({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    //final height = MediaQuery.
    return Card(
      color: (character.status == "Alive")? Colors.green:Colors.red ,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Image.network(
                character.image,
              ),
            ),
          ),
          Text(
            character.name, 
            maxLines: 1,
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            character.species,
            style: const TextStyle(color: Colors.white),
          ),
        ]
      ),
    );
  }
}