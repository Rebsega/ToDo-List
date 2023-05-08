class Tarefa {
  int? id = 0;
  String nome = '';
  bool? status = false;

  Tarefa({this.id=0, this.nome = '', this.status = false});

  Tarefa.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    nome = map['nome'];
    status = map['concluida'] == 1 ? true : false;
  }
}
