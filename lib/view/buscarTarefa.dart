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

  late Future<List<Map<String, dynamic>>> tarefasFuture = DatabaseHelper()
      .queryAll();

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
              onPressed: () {
                int id = int.parse(_tarefasInput.text);
                tarefasFuture = dbHelper.queryById(id);
                print("Tarefa buscada: ${tarefasFuture}");
              },
              child: const Text('Buscar'),
            ),
            ElevatedButton(
              onPressed: () {
                tarefasFuture = dbHelper.queryAll();
                print(tarefasFuture);
              },
              child: const Text('Buscar Todas'),
            ),
            
            SingleChildScrollView(
              child: SizedBox(
                height: 700,
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: tarefasFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final tarefas = snapshot.data!;
                      // Exibir as tarefas na UI
                      return ListView.builder(
                        itemCount: tarefas.length,
                        itemBuilder: (context, index) {
                          final tarefa = tarefas[index];
                          print('TAREFA $tarefa');
                          return ListTile(
                            title: Text(tarefa['nome'].toString()),
                            subtitle: Row(
                              children: [
                                Text(tarefa['id'].toString()),
                                Text(tarefa['status'].toString() == '0' ? 'Não' : 'Sim')
                              ],
                            )
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text('Erro ao carregar as tarefas: ${snapshot.error}');
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              )
            )
          ])),
    );
  }
}
