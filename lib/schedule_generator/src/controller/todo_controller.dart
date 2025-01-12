import 'package:flutter/cupertino.dart';
import 'package:health_buddy/schedule_generator/src/models/todo.dart';
import 'package:health_buddy/schedule_generator/src/models/todo_task.dart';
import 'package:health_buddy/schedule_generator/src/core/enums/loading_state.dart';
import 'package:health_buddy/schedule_generator/src/repositories/todo_repository.dart';

import '../models/user.dart';

class TodoController extends ChangeNotifier{
  final TodoRepository _todoRepository;

  TodoController(this._todoRepository);

  LoadingState _loadingState = LoadingState.initial;
  String _errorMessage = '';
  Todo? _todo;
  List<TodoTask> _todoTasks = [];

  //Getters
  LoadingState get loadingState => _loadingState;
  String get errorMessage => _errorMessage;
  Todo? get todo => _todo;
  List<TodoTask> get todoTasks => _todoTasks;

  //Method to fetch todo

  //Method to simulate fetching of data
  Future<void> fetchTodoTasks(DateTime date, String userId) async {
    try {
      _loadingState = LoadingState.loading;
      notifyListeners();
      const duration = Duration(seconds: 2);
      await Future.delayed(duration);
      var (a, b) = await _todoRepository.getTodoTasks(date, userId);
      _todo = a;
      _todoTasks = b;
      print(_todo);
      print("get todo success");

      _loadingState = LoadingState.loaded;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _loadingState = LoadingState.error;
      notifyListeners();
    }
  }

  Future<void> addTodoTask(TodoTask todoTask, DateTime date, String userId) async{
    try{
      _loadingState = LoadingState.loading;
      notifyListeners();

      await Future.delayed(Duration(seconds: 2));
      _todoRepository.addTodoTask(todoTask, date, userId);
      await Future.delayed(Duration(seconds: 1));
      var (a, b) = await _todoRepository.getTodoTasks(date, userId);
      _todo = a;
      _todoTasks = b;
      _loadingState = LoadingState.loaded;
      notifyListeners();
    }catch(e){
      _errorMessage = e.toString();
      _loadingState = LoadingState.error;
      notifyListeners();
    }
  }

  Future<void> genTodo(User user) async{
    try{
      _loadingState = LoadingState.loading;
      notifyListeners();

      await Future.delayed(Duration(seconds: 2));
      _todoRepository.generateTodo(user);
      notifyListeners();
    } catch(e){
      _errorMessage = e.toString();
      _loadingState = LoadingState.error;
      notifyListeners();
    }
  }

  Future<void> updateTodoTask(TodoTask todoTask, DateTime date, User user) async{
    try{
      _loadingState = LoadingState.loading;
      notifyListeners();

      await Future.delayed(Duration(seconds: 2));
      _todoRepository.updateTodoTask(todoTask, date, user);
      await Future.delayed(Duration(seconds: 1));
      var (a, b) = await _todoRepository.getTodoTasks(date, user.id.toString());
      _todo = a;
      _todoTasks = b;
      _loadingState = LoadingState.loaded;
      notifyListeners();
    }catch(e){
      _errorMessage = e.toString();
      _loadingState = LoadingState.error;
      notifyListeners();
    }
  }

  Future<void> deleteTodoTask(String userId, String taskId, DateTime date) async{
    try{
      _loadingState = LoadingState.loading;
      notifyListeners();

      await Future.delayed(const Duration(seconds: 2));
      _todoRepository.deleteTodoTask(userId, taskId, date);
      await Future.delayed(const Duration(seconds: 1));
      var (a, b) = await _todoRepository.getTodoTasks(date, userId);
      _todo = a;
      _todoTasks = b;
      _loadingState = LoadingState.loaded;
      notifyListeners();
    }catch(e){
      _errorMessage = e.toString();
      _loadingState = LoadingState.error;
      notifyListeners();
    }
  }
}
