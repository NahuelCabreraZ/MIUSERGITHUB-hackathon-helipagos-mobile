import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CoinDetailsPage extends StatefulWidget {
  final String coinId;

  CoinDetailsPage({required this.coinId});

  @override
  _CoinDetailsPageState createState() => _CoinDetailsPageState();
}

class _CoinDetailsPageState extends State<CoinDetailsPage> {
  late Future<Map<String, dynamic>> _coinDetails;

  @override
  void initState() {
    super.initState();
    _coinDetails = fetchData();
  }

  Future<Map<String, dynamic>> fetchData() async {
    final response = await http.get(
        Uri.parse('https://api.coingecko.com/api/v3/coins/${widget.coinId}'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Fallo al cargar los detalles de la moneda');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de la Moneda'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _coinDetails,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Nombre: ${snapshot.data!['name']}'),
                  Text(
                      'Precio: ${snapshot.data!['market_data']['current_price']['usd']} USD'),
                  Text(
                      'Última actualización: ${snapshot.data!['last_updated']}'),
                  Image.network(snapshot.data!['image']['large']),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error al cargar los detalles de la moneda'),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
