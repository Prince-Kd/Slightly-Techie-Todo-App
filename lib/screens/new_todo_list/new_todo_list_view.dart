import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slightly_techie_todo_app/providers/todo_provider.dart';

class NewTodoListView extends StatelessWidget {
  const NewTodoListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    TextEditingController titleController = TextEditingController();
    TextEditingController todoController = TextEditingController();

    return Consumer<TodoProvider>(builder: (context, model, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFEC7272),
          title: const Text('New Todo List'),
          actions: [
            TextButton(
              onPressed: () {
                if (todoController.text.isNotEmpty) {
                  model.addTodoList(titleController.text);
                  Navigator.pop(context);
                }
              },
              style: TextButton.styleFrom(primary: Colors.white),
              child: const Text('Save'),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      const Text(
                        'Title',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            hintText: 'Enter title of todo list',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Todos',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      model.newTodoList['todos'].isEmpty
                          ? const Center(
                              child: Text('No todos added'),
                            )
                          : ListView.separated(
                              shrinkWrap: true,
                              itemBuilder: (context, index) => Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(model.newTodoList['todos'][index]
                                      ['todo']),
                                  InkWell(
                                    onTap: () {
                                      model.removeTodoFromList(model
                                          .newTodoList['todos'][index]['todo']);
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      color: Color(0xFFEC7272),
                                    ),
                                  )
                                ],
                              ),
                              separatorBuilder: (context, index) => Divider(
                                thickness: 1.5,
                                color: Color(0xFFEC7272).withOpacity(0.5),
                              ),
                              itemCount: model.newTodoList['todos'].length,
                            ),

                      // Align(
                      //   alignment: Alignment.bottomCenter,
                      //   child: SizedBox(
                      //       height: 50,
                      //       child: ElevatedButton(
                      //         onPressed: () {},
                      //         style: ElevatedButton.styleFrom(
                      //           primary: const Color(0xFFEC7272),
                      //           shape: RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(25),
                      //           ),
                      //         ),
                      //         child: const Text('Save'),
                      //       ),
                      //   ),
                      // )
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
                        model.addTodoToList(todoController.text);
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
          ),
        ),
      );
    });
  }
}
