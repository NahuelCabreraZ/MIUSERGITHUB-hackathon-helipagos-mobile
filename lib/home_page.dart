import 'package:flutter/material.dart';
import 'coin_list.dart';
import 'fake_api_service.dart';
import 'cards_news_model.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PagingController<int, CardNewsInfo> _pagingController =
      PagingController(firstPageKey: 0);
  final DataService _dataService = DataService();

  void handleButton(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CoinList()),
    );
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await _dataService.fetchDataFromJson();
      if (newItems.isEmpty) {
        _pagingController.appendLastPage([]);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 46, 44, 44),
      appBar: AppBar(
        title: const Text('BuddyCoin'),
        backgroundColor: Colors.black,
        actions: [
          Row(
            children: [
              const Text('Lista de Monedas'),
              IconButton(
                icon: const Icon(Icons.currency_bitcoin),
                onPressed: () {
                  handleButton(context);
                },
              ),
            ],
          )
        ],
      ),
      body: PagedListView<int, CardNewsInfo>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<CardNewsInfo>(
          itemBuilder: (context, item, index) {
            return CardBuilder().buildInfoCard(item, () {
              // Aquí colocas la lógica que deseas ejecutar cuando se presiona el botón "Unirme"
              // Por ejemplo, mostrar un mensaje de éxito
              final successMessage = 'vamos a la noticia ${item.title}';
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(successMessage),
                duration: const Duration(seconds: 2),
              ));
            });
          },
          firstPageErrorIndicatorBuilder: (_) =>
              const Text('Error al cargar la primera página'),
          noItemsFoundIndicatorBuilder: (_) =>
              const Text('No se encontraron elementos'),
        ),
      ),
    );
  }
}
