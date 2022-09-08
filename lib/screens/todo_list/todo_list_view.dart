import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/todo_provider.dart';

class TodoListView extends StatelessWidget {
  final int todoListIndex;
  const TodoListView({
    Key? key,
    required this.todoListIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController todoController = TextEditingController();
    TextEditingController editController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEC7272),
        title: const Text('Todo List'),
      ),
      body: Consumer<TodoProvider>(
        builder: (context, model, child) {
          Map todoList = model.todoLists[todoListIndex];
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      const Text(
                        'Title',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Color(0xFFEC7272),
                        ),
                      ),
                      // Divider(thickness: 1.5,),
                      Text(
                        todoList['title'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Todos',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Color(0xFFEC7272),
                        ),
                      ),
                      // Divider(thickness: 1.5,),
                      const SizedBox(
                        height: 5,
                      ),
                      todoList['todos'].isEmpty
                          ? const Center(
                              child: Text('No todos added'),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                bool completed =
                                    todoList['todos'][index]['completed'];
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            offset: const Offset(1, 2),
                                            spreadRadius: 0,
                                            blurRadius: 3,
                                        )
                                      ],
                                  ),
                                  child: Row(
                                    children: [
                                      Checkbox(
                                          activeColor: const Color(0xFFEC7272),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                          ),
                                          value: completed,
                                          onChanged: (value) {
                                            model.toggleTodoCompete(
                                                todoListIndex, index, value!);
                                          },
                                      ),
                                      Expanded(
                                          child: Text(
                                        todoList['todos'][index]['todo'],
                                        style: TextStyle(
                                          decoration: completed
                                              ? TextDecoration.lineThrough
                                              : null,
                                          decorationColor:
                                              const Color(0xFFEC7272),
                                          decorationThickness: 5,
                                        ),
                                      )),
                                      PopupMenuButton(
                                        padding: const EdgeInsets.all(5),
                                        icon: const Icon(Icons.more_vert),
                                        offset: const Offset(1, 40),
                                        itemBuilder: (context) => [
                                          PopupMenuItem(
                                            onTap: () {},
                                            child: ElevatedButton(
                                              onPressed: () {
                                                editController.text = todoList['todos'][index]['todo'];
                                                Navigator.pop(context);
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return Dialog(
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(20),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              const Text(
                                                                'Edit todo',
                                                                style: TextStyle(
                                                                    fontSize: 16, fontWeight: FontWeight.w600),
                                                              ),
                                                              Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  Expanded(
                                                                    child: TextFormField(
                                                                      controller: editController,
                                                                      decoration: InputDecoration(
                                                                        contentPadding: const EdgeInsets.symmetric(
                                                                          horizontal: 15,
                                                                          vertical: 10,
                                                                        ),
                                                                        hintText: 'Enter todo',
                                                                        fillColor: Colors.white,
                                                                        filled: true,
                                                                        border: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.circular(10),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      model.editTodo(todoListIndex, index, editController.text);
                                                                      Navigator.pop(context);
                                                                      editController.clear();
                                                                    },
                                                                    child: const Icon(
                                                                      CupertinoIcons.check_mark_circled_solid,
                                                                      color: Colors.green,
                                                                      size: 40,
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      );
                                                    },
                                                );
                                              },
                                              child: Row(
                                                children: const [
                                                  Icon(
                                                    Icons.edit,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Text(
                                                    'Edit',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          PopupMenuItem(
                                              onTap: () {

                                              },
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(primary: Colors.red),
                                                onPressed: () {
                                                  model.deleteTodo(
                                                      todoListIndex,
                                                      todoList['todos'][index]
                                                      ['todo']);
                                                  Navigator.pop(context);
                                                },
                                                child: Row(
                                                  children: const [
                                                    Icon(
                                                      CupertinoIcons.delete,
                                                      color: Colors.white,
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 5,
                              ),
                              itemCount: todoList['todos'].length,
                            )
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: todoController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          hintText: 'Enter todo',
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        model.addNewTodo(todoListIndex, todoController.text);
                        todoController.clear();
                      },
                      child: const Icon(
                        CupertinoIcons.add_circled_solid,
                        color: Color(0xFFEC7272),
                        size: 40,
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
