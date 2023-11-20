import 'package:flutter/material.dart';
import 'package:httpandsqlite/database/database.dart';
import 'package:httpandsqlite/model/produto.dart';
import 'package:httpandsqlite/pages/carrinhopage.dart';
import 'package:httpandsqlite/pages/quantidade.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Compras extends StatefulWidget {
  final int id;
  const Compras(this.id, {Key? key}) : super(key: key);

  @override
  State<Compras> createState() => _ComprasState();
}

class _ComprasState extends State<Compras> {
  late SharedPreferences sharedPreferences;
  late DataBase _database;
  List<Produto> produtos = [];

  @override
  void initState() {
    super.initState();
    _initDatabaseAndLoadProdutos();
  }

  _initDatabaseAndLoadProdutos() async {
    sharedPreferences = await SharedPreferences.getInstance();
    await _initDatabase();
    await _loadProdutos();
  }

  _initDatabase() async {
    _database = DataBase();
    await _database.openDatabaseConnection();
  }

  _loadProdutos() async {
    List<Produto> produtosList = await _database.getAllProdutos();
    setState(() {
      produtos = produtosList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selecione um Produto')),
      body: ListView.builder(
        itemCount: produtos.length,
        itemBuilder: (context, index) {
          Produto produto = produtos[index];
          return ListTile(
            title: Text('${produto.nome} - R\$ ${produto.preco.toString()}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InformarQuantidade(produto),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CarrinhoPage(),
            ),
          );
        },
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}
