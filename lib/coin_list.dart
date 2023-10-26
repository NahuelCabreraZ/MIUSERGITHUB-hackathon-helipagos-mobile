import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'coins_details.dart';
import 'nfts_list.dart';

//TAMBIEN SE ME OCURRIÓ QUE EN VEZ DE QUE NAVEGUE A OTRA PANTALLA CON LOS DETALLES DE LA MONEDA
//QUE CON UNA API GENERAL, GUARDAS TODOS LOS CAMPOS NECESARIOS, Y MOSTRAS SOLO LOS PRINCIPALES,
// Y SI EL USUARIO HACE TAP SOBRE LA MONEDA, QUE HAGA UNA ANIMACION DE FLIP Y QUE SE MUESTREN
//LOS OTROS DETALLES QUE ESTABAN CARGADOS PERO SOLAMENTE SIN MOSTRARSE.
//COMO PARA NO TENER QUE HACER DOS LLAMADOS A APIS.

class Coin {
  final String id;
  final String name;
  final String symbol;
  final String image;
  final num currentPrice;
  final String lastUpdated;

  Coin(
      {required this.id,
      required this.name,
      required this.symbol,
      required this.image,
      required this.currentPrice,
      required this.lastUpdated});

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
      image: json['image'],
      currentPrice: json['current_price'],
      lastUpdated: json['last_updated'],
    );
  }
}

class CoinList extends StatefulWidget {
  const CoinList({Key? key}) : super(key: key);

  @override
  CoinListState createState() => CoinListState();
}

class CoinListState extends State<CoinList> {
  late Future<List<Coin>> _coinData;

  @override
  void initState() {
    super.initState();
    _coinData = fetchData();
  }

  Future<List<Coin>> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&page=1&sparkline=false&locale=en'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Coin> coins = [];
      data.forEach((element) {
        coins.add(Coin.fromJson(element));
      });
      return coins;
    } else {
      throw Exception('Fallo al cargar los datos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Monedas'),
        actions: [
          Row(
            children: [
              const Text('NftList'),
              IconButton(
                icon: const Icon(Icons.currency_bitcoin),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NftsList(),
                    ),
                  );
                  ;
                },
              ),
            ],
          )
        ],
      ),
      body: FutureBuilder<List<Coin>>(
        future: _coinData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              itemCount: snapshot.data!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                return Card(
                  child: InkWell(
                    onTap: () {
                      // Navegar a la pantalla de detalles de la moneda pasando el ID de la moneda
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CoinDetailsPage(coinId: snapshot.data![index].id),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height:
                              75, // Ajusta la altura de la imagen según sea necesario
                          width:
                              75, // Ajusta el ancho de la imagen según sea necesario
                          child: Image.network(
                            snapshot.data![index].image,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text('Nombre: ${snapshot.data![index].name}'),
                        Text('Símbolo: ${snapshot.data![index].symbol}'),
                        Text(
                            'Precio actual: ${snapshot.data![index].currentPrice}'),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error al cargar los datos'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
