import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/entity/todo.dart';
import 'package:todo_riverpod/services/uuid/uuid_service.dart';

final homeProvider = NotifierProvider.autoDispose<HomeNotifier, List<Todo>>(
  HomeNotifier.new,
);

final class HomeNotifier extends AutoDisposeNotifier<List<Todo>> {
  @override
  List<Todo> build() {
    return const [];
  }

  void addTodo(String name) {
    final newTodo = Todo(
      id: ref.read(uuidProvider).v4(),
      name: name,
    );

    state = [
      newTodo,
      ...state,
    ];
  }

  void remoteTodo(String id) {
    state = [
      for (final todo in state)
        if (todo.id != id) todo
    ];
  }

  void toggleComplete(String todoId) {
    state = [
      for (final item in state)
        if (item.id == todoId)
          item.copyWith(isCompleted: !item.isCompleted)
        else
          item
    ];
  }
}
