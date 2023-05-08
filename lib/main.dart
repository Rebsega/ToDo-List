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
  DatabaseHelper dbHelper = DatabaseHelper();

  List<Object> _tarefasBuscadas = [];

  List<Tarefa> listaDeTarefasTarefa = [];

  final TextEditingController _tarefasController = TextEditingController();

  @override
  void initState() {
    super.initState();
    buscaTarefinhas();
  }

  buscaTarefinhas() async {
    _tarefasBuscadas = await dbHelper.queryAll();
    _tarefasBuscadas.forEach((element) {
      print('aaaaaa $element');
    });

    for (var elemento in _tarefasBuscadas) {
      if (elemento is Tarefa) {
        listaDeTarefasTarefa.add(elemento);
      }
    }
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
                  setState(() {
                    listaDeTarefasTarefa.add(Tarefa(
                        id: listaDeTarefasTarefa.length + 1,
                        nome: _tarefasController.text));
                    dbHelper.insert({'tarefa': _tarefasController.text});
                    _tarefasController.text = "";
                  });
                },
                child: const Text('Adicionar tarefa')),
            Column(
              children: listaDeTarefasTarefa.map((tarefa) {
                print("TAREFINHAAAAAAA ${tarefa.toString()}");
                return Text(tarefa.nome);
              }).toList(),
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

            /*Expanded(                
                child: Column(
                  children: listaDeTarefasTarefa.map((tarefa) => ListTile(
                    title: Text(tarefa.nome),
                    subtitle: Text(tarefa.id.toString()),
                    trailing: Checkbox(
                      value: tarefa.status,
                      onChanged: (bool? value) {
                        setState(() {
                          tarefa.status = value!;
                        });
                      },
                    ),
                  )).toList(),
                ),
              )*/
          ]),
        ));
  }
}
