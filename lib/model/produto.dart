class Produto {
  final dynamic id;
  final dynamic nome;
  final dynamic preco;
  final dynamic quantidade;

  Produto(
      {required this.id,
      required this.nome,
      required this.preco,
      this.quantidade});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'preco': preco,
      'quantidade': quantidade,
    };
  }

  factory Produto.fromMap(Map<String, dynamic> map) {
    return Produto(
      id: map['id'],
      nome: map['nome'],
      preco: map['preco'],
      quantidade: map['quantidade'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'preco': preco,
      'quantidade': quantidade,
    };
  }

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      nome: json['nome'],
      preco: json['preco'],
      quantidade: json['quantidade'],
    );
  }
}
