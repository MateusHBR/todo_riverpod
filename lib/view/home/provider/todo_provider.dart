import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/entity/todo.dart';
import 'package:todo_riverpod/service/local_storage/local_storage.dart';
import 'package:todo_riverpod/service/uuid/uuid_service.dart';

const _kTodoStorageKey = 'todos';
final asyncTodosProvider =
    AsyncNotifierProvider.autoDispose<TodoNotifier, List<Todo>>(
  TodoNotifier.new,
);

final class TodoNotifier extends AutoDisposeAsyncNotifier<List<Todo>> {
  @override
  Future<List<Todo>> build() {
    return _fetchTodos();
  }

  Future<List<Todo>> _fetchTodos() async {
    final todos = await ref.read(localStorageServiceProvider).get(
          _kTodoStorageKey,
        );
    if (todos == null) return const [];

    return (jsonDecode(todos) as List)
        .cast<Map<String, dynamic>>()
        .map(Todo.fromJson)
        .toList();
  }

  Future<void> _saveTodosState() async {
    if (!state.hasValue) return;
    await ref.read(localStorageServiceProvider).save(
          key: _kTodoStorageKey,
          data: jsonEncode(state.value!),
        );
  }

  void addTodo(String name) async {
    final newTodo = Todo(
      id: ref.read(uuidServiceProvider).v4(),
      name: name,
    );

    state = AsyncValue.data([
      newTodo,
      ...state.valueOrNull ?? [],
    ]);
    await _saveTodosState();
  }

  void removeTodo(String id) async {
    if (!state.hasValue) return;

    state = AsyncValue.data([
      for (final todo in state.value!)
        if (todo.id != id) todo
    ]);
    await _saveTodosState();
  }

  void toggleComplete(String todoId) async {
    if (!state.hasValue) return;

    state = AsyncValue.data([
      for (final item in state.value!)
        if (item.id == todoId)
          item.copyWith(isCompleted: !item.isCompleted)
        else
          item
    ]);
    await _saveTodosState();
  }
}
