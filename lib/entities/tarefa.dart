class Tarefa {
  int id = 0;
  String nome = '';
  bool status = false;

  Tarefa({required this.id, required this.nome, required this.status});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'status': status ? 1 : 0,
    };
  }
}
