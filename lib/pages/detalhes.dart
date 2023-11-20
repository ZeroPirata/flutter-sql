import 'package:flutter/material.dart';
import 'package:httpandsqlite/model/produto.dart';

class DetalhesProduto extends StatelessWidget {
  final Produto produto;

  const DetalhesProduto({Key? key, required this.produto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Produto: ${produto.nome}'),
            Text('Quantidade: ${produto.quantidade}'),
            Text(
                'Valor: R\$ ${(produto.preco! * double.tryParse(produto.quantidade.toString())!).toStringAsFixed(2)}'),
            if (produto.quantidade != null && produto.quantidade! >= 10)
              Text(
                'Desconto: R\$ ${(produto.preco! * double.tryParse(produto.quantidade.toString())! * 0.05).toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.green),
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Pedido enviado com sucesso!')),
                    );
                  },
                  child: const Text('Enviar Pedido'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text('Cancelar Pedido'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
