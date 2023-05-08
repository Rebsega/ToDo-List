import 'dart:io';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Tarefa {
  String nome;
  bool concluida;

  Tarefa({required this.nome, this.concluida = false});
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
  final List<Tarefa> _tarefas = [];

  final TextEditingController _tarefasController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Minha to-do List'),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
          
            children: [            
              TextField(
                controller: _tarefasController,
                decoration: const InputDecoration(
                  hintText: 'Digite o nome da tarefa',
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _tarefas.add(Tarefa(nome: _tarefasController.text));
                      _tarefasController.text = "";
                    });
                  },
                  child: const Text('Adicionar tarefa')
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: _tarefas.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                      title: Text(_tarefas[index].nome),                      
                      trailing: Checkbox(
                    value: _tarefas[index].concluida,
                    onChanged: (bool? value) {
                      setState(() {
                        _tarefas[index].concluida = value!;
                      });
                    },
                  ),
                        
                    );
                    },
                )
              )
            ]
          ),
        )
        );
  }
}
