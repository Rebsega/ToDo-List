import 'dart:io';

import 'package:first_project/database/databaseHelper.dart';
import 'package:first_project/entities/tarefa.dart';
import 'package:first_project/view/buscarTarefa.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minha to-do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TodoList(title: 'Flutter Demo Home Page'),
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({super.key, required this.title});
  final String title;


  @override
  State<TodoList> createState() => _MyTodoListState();
}

class _MyTodoListState extends State<TodoList> {
  @override
  void initState() {
    super.initState();
    atualizarTarefas();
  }

  DatabaseHelper dbHelper = DatabaseHelper();
  bool _isChecked = false;

  late Future<List<Map<String, dynamic>>> tarefasFuture = DatabaseHelper()
      .queryAll();

  final TextEditingController _tarefasController = TextEditingController();

  atualizarTarefas() {
    tarefasFuture = dbHelper.queryAll();
    print("Atualizando Tarefas");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Minha to-do List'),
        ),
        body: Container(
          color: Colors.white,
          child: Column(children: [
            TextField(
              controller: _tarefasController,
              decoration: const InputDecoration(
                hintText: 'Digite o nome da tarefa',
              ),
            ),
            ElevatedButton(
                onPressed: () {

                    atualizarTarefas();

                },
                child: const Text('Atualizar Tarefas')
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() async {
                    await dbHelper.insert({
                      'nome': _tarefasController.text,
                      'status': false
                    });
                    _tarefasController.text = "";
                  });
                },
                child: const Text('Adicionar tarefa')),
            Column(
              children: [
                SizedBox(
                  height: 600,
                  child: FutureBuilder<List<Map<String, dynamic>>> (
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
                                    Text('ID: ${tarefa['id'].toString()}  '),
                                    Text(tarefa['status'].toString() == '0' ? 'Não' : 'Sim'),
                                    Checkbox(
                                        value: _isChecked,
                                        onChanged: (bool? value) async {

                                          int rowsAffected = await dbHelper.updateStatus(tarefa['id'], value!);
                                          setState(() {
                                            _isChecked = value;
                                          });
                                          print("ROWS $rowsAffected");
                                        }
                                    )
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


              ]
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const BuscarTarefa(title: '')));
                  });
                },
                child: const Text('Buscar Tarefa')),
          ]),
        ));
  }
}
