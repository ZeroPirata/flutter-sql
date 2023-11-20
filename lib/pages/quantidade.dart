import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:httpandsqlite/model/produto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InformarQuantidade extends StatefulWidget {
  final Produto produto;

  const InformarQuantidade(this.produto, {super.key});

  @override
  State<InformarQuantidade> createState() => _InformarQuantidadeState();
}

class _InformarQuantidadeState extends State<InformarQuantidade> {
  late SharedPreferences sharedPreferences;
  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  void _initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  int quantidade = 1;

  Future<void> _adicionarListaProduto(int quantidade) async {
    List<Map<String, dynamic>> produtos = [];
    String? produtosJson = sharedPreferences.getString('produtos');
    if (produtosJson != null && produtosJson.isNotEmpty) {
      produtos = List<Map<String, dynamic>>.from(jsonDecode(produtosJson));
    }
    bool produtoExistente = false;
    for (int i = 0; i < produtos.length; i++) {
      if (produtos[i]['id'] == widget.produto.id) {
        produtos[i]['quantidade'] += quantidade;
        produtos[i]['preco'] += widget.produto.preco;
        produtoExistente = true;
        break;
      }
    }
    if (!produtoExistente) {
      Map<String, dynamic> novoProduto = {
        "id": widget.produto.id,
        "nome": widget.produto.nome,
        "preco": widget.produto.preco,
        "quantidade": quantidade,
      };
      produtos.add(novoProduto);
    }
    sharedPreferences.setString('produtos', jsonEncode(produtos));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Informe a Quantidade')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Produto: ${widget.produto.nome}'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Quantidade:'),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: () {
                    setState(() {
                      quantidade = (quantidade > 1) ? quantidade - 1 : 1;
                    });
                  },
                  child: const Icon(Icons.remove),
                ),
                Text(quantidade.toString()),
                TextButton(
                  onPressed: () {
                    setState(() {
                      quantidade++;
                    });
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _adicionarListaProduto(quantidade);
                Navigator.pop(context);
              },
              child: const Text('Adicionar ao Carrinho'),
            ),
          ],
        ),
      ),
    );
  }
}
