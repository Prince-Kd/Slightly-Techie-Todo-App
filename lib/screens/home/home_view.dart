import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:slightly_techie_todo_app/providers/todo_provider.dart';
import 'package:slightly_techie_todo_app/screens/new_todo_list/new_todo_list_view.dart';
import 'package:slightly_techie_todo_app/screens/todo_list/todo_list_view.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Slightly Techie Todo App'),
        backgroundColor: const Color(0xFFEC7272),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Todo lists',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ValueListenableBuilder(
                valueListenable: Hive.box('settings').listenable(),
                builder: (context, Box box, child) {
                  List todoLists = box.get('todoLists', defaultValue: []);
                  if (todoLists.isEmpty) {
                    return const Center(
                      child: Text('You have no todo lists'),
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      int completedCount = todoLists[index]["todos"]
                          .where((todo) => todo['completed'] == true)
                          .toList()
                          .length;
                      int totalTodos = todoLists[index]['todos'].length;
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TodoListView(todoListIndex: index),
                            ),
                          );
                        },
                        child: Consumer<TodoProvider>(
                          builder: (context, model, child) {
                            return Slidable(
                              key: const ValueKey(0),
                              endActionPane: ActionPane(
                                extentRatio: 0.3,
                                dragDismissible: false,
                                motion: const ScrollMotion(),
                                dismissible: DismissiblePane(onDismissed: () {}),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) {
                                      model.deleteTodoList(index);
                                    },
                                    backgroundColor: const Color(0xFFFE4A49),
                                    foregroundColor: Colors.white,
                                    icon: CupertinoIcons.delete,
                                    label: 'Delete',
                                    borderRadius: BorderRadius.horizontal(
                                        right: Radius.circular(20)),
                                  ),
                                ],
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          const Color(0xFFEC7272).withOpacity(0.1),
                                      spreadRadius: 3,
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    )
                                  ],
                                ),
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          todoLists[index]['title'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                          ),
                                        ),
                                        // Text(Jiffy(DateTime.now()).yMMMMd),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            value: completedCount/totalTodos,
                                            strokeWidth: 2,
                                            color: completedCount == totalTodos ? Colors.green : const Color(0xFFEC7272),
                                            backgroundColor:
                                                Colors.grey.withOpacity(0.5),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text('$completedCount/$totalTodos')
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                    itemCount: box.get('todoLists').length,
                  );
                })
          ],
        ),
      ),
      floatingActionButton: Consumer<TodoProvider>(
        builder: (context, model, child) {
          return FloatingActionButton(
            onPressed: () {
              model.resetNewTodoList();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NewTodoListView(),
                ),
              );
            },
            backgroundColor: const Color(0xFFEC7272),
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }
}
