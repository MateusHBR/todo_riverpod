import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/view/home/provider/todo_provider.dart';

class TodoListView extends ConsumerWidget {
  const TodoListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTodos = ref.watch(asyncTodosProvider);

    return asyncTodos.when(
      error: (_, __) => const SizedBox(),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      data: (todos) {
        return ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            return Dismissible(
              key: Key('TodoItem.${todo.id}'),
              background: const ColoredBox(color: Colors.red),
              onDismissed: (_) =>
                  ref.read(asyncTodosProvider.notifier).removeTodo(todo.id),
              child: ListTile(
                title: Text(todo.name),
                onTap: () => ref
                    .read(asyncTodosProvider.notifier)
                    .toggleComplete(todo.id),
                trailing: Checkbox(
                  value: todo.isCompleted,
                  onChanged: (_) => ref
                      .read(asyncTodosProvider.notifier)
                      .toggleComplete(todo.id),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
