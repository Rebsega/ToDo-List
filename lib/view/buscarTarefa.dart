import 'package:first_project/database/databaseHelper.dart';
import 'package:first_project/entities/tarefa.dart';
import 'package:flutter/material.dart';

class BuscarTarefa extends StatefulWidget {
  final String title;
  const BuscarTarefa({super.key, required this.title});

  @override
  State<BuscarTarefa> createState() => _BuscarTarefaState();
}

class _BuscarTarefaState extends State<BuscarTarefa> {
  DatabaseHelper dbHelper = DatabaseHelper();

  final TextEditingController _tarefasInput = TextEditingController();

  late Tarefa tarefaBuscada = Tarefa(id: 0, nome: '', status: false);

  List<Object> aux = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Tarefa'),
      ),
      body: Container(
          color: Colors.red,
          child: Column(children: [
            TextField(
              controller: _tarefasInput,
              decoration: const InputDecoration(
                hintText: 'Digite o numero da tarefa',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                int id = int.parse(_tarefasInput.text);
                Object aux = await dbHelper.queryById(id);
                print("Tarefa buscada: ${aux.toString()}");
              },
              child: const Text('Buscar'),
            ),
            ElevatedButton(
              onPressed: () async {
                aux = await dbHelper.queryAll();
                aux.forEach((element) {
                  print(element.toString());
                });
              },
              child: const Text('Buscar Todas'),
            ),
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: FutureBuilder<List<Object>>(
                  future: dbHelper.queryAll(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Object>> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.data!.isEmpty) {
                      return Text('Nenhuma tarefa encontrada.');
                    } else {
                      return _buildTarefasList(snapshot.data!);
                    }
                  },
                ),
              ),
            ),
          ])),
    );
  }
}


Widget _buildTarefasList(List<Object> tarefasObject) {
    return Column(
    children: tarefasObject.map((tarefa) => ListTile(
      title: Text(tarefa.toString()),
      subtitle: Text(tarefa.toString()),
      trailing: Checkbox(
        value: tarefa == 1 ? true : false,
        onChanged: (value) {
          tarefa = value! ? true : false;

        },
      ),
    )).toList(),
  );
}
