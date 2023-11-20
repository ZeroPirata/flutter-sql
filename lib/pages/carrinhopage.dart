import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:httpandsqlite/database/database.dart';
import 'package:httpandsqlite/model/produto.dart';
import 'package:httpandsqlite/pages/detalhes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CarrinhoPage extends StatefulWidget {
  const CarrinhoPage({Key? key}) : super(key: key);

  @override
  State<CarrinhoPage> createState() => _CarrinhoPageState();
}

class _CarrinhoPageState extends State<CarrinhoPage> {
  late SharedPreferences sharedPreferences;
  late DataBase _database;
  late List<Produto> produtos;

  @override
  void initState() {
    super.initState();
    produtos = [];
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

  Future<void> _loadProdutos() async {
    List<Produto> produtosList = await _database.getProdutos(sharedPreferences);
    setState(() {
      produtos = produtosList;
    });
  }

  Future<void> _removerProduto(Produto produto) async {
    List<Produto> produtos = await _database.getProdutos(sharedPreferences);
    produtos.removeWhere((p) => p.id == produto.id);
    sharedPreferences.setString('produtos', jsonEncode(produtos));
    await _loadProdutos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho de Compras'),
      ),
      body: produtos.isNotEmpty
          ? ListView.builder(
              itemCount: produtos.length,
              itemBuilder: (context, index) {
                Produto produto = produtos[index];

                return Dismissible(
                  key: Key(produto.id.toString()),
                  onDismissed: (direction) {
                    _removerProduto(produto);
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    title: Text('Produto: ${produto.nome}'),
                    subtitle: Text('Quantidade: ${produto.quantidade}'),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Valor: R\$ ${(produto.preco * double.tryParse(produto.quantidade.toString())!).toStringAsFixed(2)}'),
                        if (produto.quantidade != null &&
                            produto.quantidade! >= 10)
                          Text(
                            'Desconto: R\$ ${(produto.preco * double.tryParse(produto.quantidade.toString())! * 0.05).toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.green),
                          ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetalhesProduto(produto: produto),
                        ),
                      );
                    },
                  ),
                );
              },
            )
          : const Center(
              child: Text('Nenhum produto no carrinho.'),
            ),
    );
  }
}
