import 'dart:convert';
import 'package:crud_app/models/todo.dart';
import 'package:http/http.dart' as http;

class TodoService {
  static const String apiUrl = 'https://crudcrud.com/api/ba960e50c05b416781b1943741c85f5f/todos';
// Fetch todos from the API
  Future<List<Todo>> fetchTodos() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((todo) => Todo.fromJson(todo)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }

// Add a new todo
  Future<void> addTodo(Todo todo) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode(todo.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add new todo');
    }
  }

// Update todo title (keeping the checkbox state unchanged)
  Future<void> updateTodoTitle(Todo todo) async {
    final response = await http.put(
      Uri.parse('$apiUrl/${todo.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'title': todo.title,
        'completed': todo.completed,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update todo title');
    }
  }

// Delete a todo
  Future<void> deleteTodo(String id) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/$id'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete todo');
    }
  }
}
