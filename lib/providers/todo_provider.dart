import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TodoProvider extends ChangeNotifier{
  List _todoLists = Hive.box('settings').get('todoLists', defaultValue: []);

  Map _newTodoList = {
    "title": "",
    "todos": [],
  };

  List get todoLists => _todoLists;
  Map get newTodoList => _newTodoList;

  resetNewTodoList(){
    _newTodoList = {
      "title": "",
      "todos": [],
    };
    notifyListeners();
  }

  addTodoToList(String todoText){
    _newTodoList['todos'].add({"todo": todoText, "completed": false});
    notifyListeners();
  }

  removeTodoFromList(String todo){
    _newTodoList['todos'].removeWhere((item) => item['todo'] == todo);
    notifyListeners();
  }

  addTodoList(String title){
    _newTodoList['title'] = title;
    _todoLists.add(_newTodoList);
    Hive.box('settings').put('todoLists', _todoLists);
    print(_todoLists);
    notifyListeners();
  }

  toggleTodoCompete(int listIndex, int todoIndex, bool value){
    _todoLists[listIndex]['todos'][todoIndex]['completed'] = value;
    Hive.box('settings').put('todoLists', _todoLists);
    notifyListeners();
  }

  addNewTodo(int listIndex, String todo,){
    _todoLists[listIndex]['todos'].add({"todo" : todo, "completed": false});
    Hive.box('settings').put('todoLists', _todoLists);
    notifyListeners();
  }

  deleteTodo(int listIndex, String todo,){
    (_todoLists[listIndex]['todos'] as List).removeWhere((i) => i['todo'] == todo);
    Hive.box('settings').put('todoLists', _todoLists);
    notifyListeners();
  }

  editTodo(int listIndex, int todoIndex, String newTodo){
    _todoLists[listIndex]['todos'][todoIndex]["todo"] = newTodo;
    Hive.box('settings').put('todoLists', _todoLists);
    notifyListeners();
  }

  deleteTodoList(int listIndex){
    _todoLists.removeAt(listIndex);
    Hive.box('settings').put('todoLists', _todoLists);
    notifyListeners();
  }
}