import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:rick_morty_app/dao/character_dao.dart';
import 'package:rick_morty_app/models/character.dart';
import 'package:rick_morty_app/screens/character_detail_screen.dart';
import 'package:rick_morty_app/services/character_service.dart';

class CharacterListScreen extends StatelessWidget{

  const CharacterListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Rick & Morty', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: const CharacterList(),
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
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 5.0,
        childAspectRatio: 0.6
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

class CharacterItem extends StatefulWidget {
  final Character character;
  //dynamic
  const CharacterItem({super.key, required this.character});

  @override
  State<CharacterItem> createState() => _CharacterItemState();
}

class _CharacterItemState extends State<CharacterItem> {
  bool _isFavorite = false;
  final CharacterDao _characterDao = CharacterDao();

  @override
  Widget build(BuildContext context) {
    _characterDao.isFavorite(widget.character).then(
      (value) {
        if(mounted){
          setState(() {
            _isFavorite = value;
          });
        }
      }
    );

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CharacterDetailsScreen(character: widget.character),
          ),
        );
      },
      child: Card(
        color: (widget.character.status == "Alive")? Colors.green:Colors.red ,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  widget.character.image,
                ),
              ),
            ),
            Text(
              widget.character.name, 
              maxLines: 1,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.character.species,
              style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _isFavorite = !_isFavorite;
                });

                _isFavorite
                  ? _characterDao.insert(widget.character)               
                  : _characterDao.delete(widget.character);
              },
              icon: Icon(_isFavorite? Icons.favorite:Icons.favorite_border,
                color: _isFavorite? Colors.purple:Colors.black,
              ),
            )
          ]
        ),
      )
    );
  }
}