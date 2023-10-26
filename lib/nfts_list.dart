import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Nfts {
  final String id;
  final String name;
  final String contractAddress;
  final String assetPlatformId;
  final String symbol;

  Nfts(
      {required this.id,
      required this.name,
      required this.contractAddress,
      required this.assetPlatformId,
      required this.symbol});

  factory Nfts.fromJson(Map<String, dynamic> json) {
    return Nfts(
      id: json['id'],
      name: json['name'],
      contractAddress: json['contract_address'],
      assetPlatformId: json['asset_platform_id'],
      symbol: json['symbol'],
    );
  }
}

class NftsList extends StatefulWidget {
  const NftsList({Key? key}) : super(key: key);

  @override
  NftListState createState() => NftListState();
}

class NftListState extends State<NftsList> {
  late Future<List<Nfts>> _coinData;

  @override
  void initState() {
    super.initState();
    _coinData = fetchData();
  }

  Future<List<Nfts>> fetchData() async {
    final response = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/nfts/list?per_page=5&page=1'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Nfts> coins = [];
      data.forEach((element) {
        coins.add(Nfts.fromJson(element));
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
      ),
      body: FutureBuilder<List<Nfts>>(
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Nombre: ${snapshot.data![index].name}'),
                      Text(
                          'Direccion de Contrato: ${snapshot.data![index].contractAddress}'),
                      Text(
                          'Precio actual: ${snapshot.data![index].assetPlatformId}'),
                    ],
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
