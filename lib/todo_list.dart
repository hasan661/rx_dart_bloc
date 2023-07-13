import 'package:flutter/material.dart';
import 'home_bloc.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  TodoListState createState() => TodoListState();
}

class TodoListState extends State<TodoList> {
  final _bloc = HomeBloc();

  final TextEditingController todoItem = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TODO DUMMY APP"),
        centerTitle: true,
      ),
      body: StreamBuilder<List<String>>(
        stream: _bloc.dataStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 20,
                    right: 20,
                  ),
                  child: TextFormField(
                    onChanged: (value) {
                      _bloc.buttonEnabled(
                        todoItem.text,
                      );
                    },
                    controller: todoItem,
                    decoration: InputDecoration(
                        errorMaxLines: 2,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: StreamBuilder<bool>(
                          stream: _bloc.buttonStream,
                          builder: (context, snapshot) {
                            return TextButton(
                              onPressed: todoItem.text.isNotEmpty
                                  ? () {
                                      _bloc.addData(todoItem.text);
                                      todoItem.clear();
                                    }
                                  : null,
                              child: const Text("Add"),
                            );
                          },
                        )),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              title: Text(
                                  snapshot.data?[index] ?? "No data available"),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                _bloc.removeData(index);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ))
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("An error occurred: ${snapshot.error}"),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
