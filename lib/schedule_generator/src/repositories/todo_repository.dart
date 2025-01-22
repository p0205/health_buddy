import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:health_buddy/schedule_generator/src/models/todo.dart';
import 'package:health_buddy/schedule_generator/src/models/todo_task.dart';

import '../models/user.dart';
import 'package:health_buddy/constants.dart' as Constants;

class TodoRepository{


  //get Todo and TodoTasks using userId and date
  Future<(Todo?, List<TodoTask>)> getTodoTasks(DateTime date, String userId) async {
    Todo? selectedTodo;
    List<TodoTask> selectedTodoTasks = [];

    try {
      // Format the date as a string (adjust formatting if needed)
      String formattedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

      // Fetch Todos by sending a POST request with body
      final todoResponse = await http.get(

        Uri.parse(Constants.ScheduleUrl + Constants.SchedulePort + '/api/v1/todos/'+userId+"/"+formattedDate),

        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
      );
      print(todoResponse.body);

      if (todoResponse.statusCode == 200) {
        //print('Data fetched successfully');
        var responseJson = json.decode(todoResponse.body);
        if (responseJson.isNotEmpty) {
          // add from Json function
          // Access the nested 'todo' object
          Map<String, dynamic> todoJson = responseJson['todo'];

          // Create a Todo instance from the nested 'todo' object
          selectedTodo = await Todo.fromJson(todoJson);

          selectedTodoTasks = (responseJson['todoTasks'] as List<dynamic>)
              .map((task) => TodoTask.fromJson(task as Map<String, dynamic>))
              .toList();
        }
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
    return (selectedTodo, selectedTodoTasks);
  }

  //generate Todo
  Future<void> generateTodo(User user) async{
    try{
      print("Fetching data...");
      final userJson = user.toJson(); // or use toJsonSnakeCase() if your API expects snake_case
      final encodedBody = json.encode(userJson);

      // Fetch Todos by sending a POST request with body
      final userResponse = await http.post(

        Uri.parse(Constants.ScheduleUrl + Constants.SchedulePort + '/api/v1/schedule'), //change api url - ip address needed if using physical device

        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: encodedBody,
      );
      if (userResponse.statusCode == 200) {
        var responseJson = json.decode(userResponse.body);
        if (responseJson.isNotEmpty) {
          print("schedule create successful");
        } else {
          print('User is null');
        }
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  void addTodoTask(TodoTask todoTask, DateTime date, String userId) async {
    try{
      final todoTaskJson = todoTask.toJson(); // or use toJsonSnakeCase() if your API expects snake_case
      final encodedBody = json.encode(todoTaskJson);
      final formattedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

      // Fetch Todos by sending a POST request with body
      final userResponse = await http.post(
        Uri.parse(Constants.ScheduleUrl + Constants.SchedulePort + '/api/v1/todos/'+ userId + '/' + formattedDate),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: encodedBody,
      );
      if (userResponse.statusCode == 200) {
        var responseJson = json.decode(userResponse.body);
        if (responseJson.isNotEmpty) {
          print("schedule create successful");
        } else {
          print('User is null');
        }
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Future<void> updateTodoTask(TodoTask todoTask, DateTime date ,User user) async {
    try{
      final todoTaskJson = todoTask.toJson(); // or use toJsonSnakeCase() if your API expects snake_case
      final encodedBody = json.encode(todoTaskJson);
      final userId = user.id.toString();

      // Convert DateTime to string date only
      String formattedDate = date.toIso8601String().split('T')[0];
      print(encodedBody);
      print(formattedDate);

      final userResponse = await http.put(
        Uri.parse(Constants.ScheduleUrl + Constants.SchedulePort + '/api/v1/todos/'+ userId + '/' + formattedDate),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: encodedBody,
      );
      if (userResponse.statusCode == 200) {
        var responseJson = json.decode(userResponse.body);
        if (responseJson.isNotEmpty) {
          print("schedule update successful");
        } else {
          print('User is null');
        }
      }
    }
    catch (error) {
      print('Error fetching data: $error');
    }
  }

  Future<void> deleteTodoTask(String userId, String taskId, DateTime date) async {
    try{
      // Convert DateTime to string date only
      String formattedDate = date.toIso8601String().split('T')[0];

      final userResponse = await http.delete(
        Uri.parse(Constants.ScheduleUrl + Constants.SchedulePort + '/api/v1/todos/'+ userId + '/' + taskId + '/' + formattedDate),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
      );
      if (userResponse.statusCode == 200) {
        var responseJson = json.decode(userResponse.body);
        if (responseJson.isNotEmpty) {
          print("schedule delete successful");
        } else {
          print('User is null');
        }
      }
    }
    catch (error) {
      print('Error fetching data: $error');
    }
  }
}