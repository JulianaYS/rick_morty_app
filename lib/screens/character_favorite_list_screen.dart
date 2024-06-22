import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:rick_morty_app/dao/character_dao.dart';
import 'package:rick_morty_app/models/character.dart';
import 'package:rick_morty_app/models/character_favorite.dart';
import 'package:rick_morty_app/screens/character_detail_screen.dart';


class CharacterFavoriteListScreen extends StatefulWidget {
  const CharacterFavoriteListScreen({super.key});

  @override
  State<CharacterFavoriteListScreen> createState() => _CharacterFavoriteListScreenState();
}

class _CharacterFavoriteListScreenState extends State<CharacterFavoriteListScreen> {
  final PagingController<int, CharacterFavorite> _pagingController = PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage();
    });
    super.initState();
  }

  Future<void> _fetchPage() async {
    try {
      final newItems = await CharacterDao().fetchAll();
      _pagingController.appendLastPage(newItems);
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Favorite Rick & Morty characters', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: PagedGridView<int, CharacterFavorite>(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 5.0,
          childAspectRatio: 0.7,
        ),
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<CharacterFavorite>(
          itemBuilder: (context, item, index) => InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CharacterDetailsScreen(character: Character(id: item.id, name: item.name, image: item.image, species: item.species, status: item.status),
                  ),
                )
              );
            },
            child: Card(
              color: (item.status == "Alive")? Colors.green:Colors.red,
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        item.image,
                      ),
                    ),
                  ),
                  Text(
                    item.name,
                    maxLines: 1,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    item.species,
                    style: const TextStyle(color: Color.fromARGB(179, 0, 0, 0)),
                  ),
                ],
              ),
            ),
          ),    
        ),
      )
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}