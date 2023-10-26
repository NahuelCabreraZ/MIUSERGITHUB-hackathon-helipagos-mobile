import 'fake_api_service.dart'; // Importa el servicio de datos
import 'cards_news_model.dart'; // Importa el modelo de tarjeta de información
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class PaginationLogic {
  final DataService _dataService = DataService();
  final PagingController<int, CardNewsInfo> pagingController;
  final DataService dataService;

  PaginationLogic(this.pagingController, this.dataService);

  Future<List<CardNewsInfo>> fetchPage(int pageKey) async {
    try {
      final List<CardNewsInfo> pageData =
          await _dataService.fetchDataFromJson();
      return pageData;
    } catch (error) {
      // Manejar errores, como cuando no se pueden cargar los datos.
      throw error;
    }
  }
}
