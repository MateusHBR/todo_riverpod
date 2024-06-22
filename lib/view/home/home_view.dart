import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/view/home/home_provider.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final textFieldController = TextEditingController();

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textFieldController,
                  ),
                ),
                const SizedBox(width: 8),
                ValueListenableBuilder(
                  valueListenable: textFieldController,
                  builder: (context, value, __) {
                    final isEnabled = value.text.isNotEmpty;
                    return IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: isEnabled
                          ? () {
                              ref
                                  .read(homeProvider.notifier)
                                  .addTodo(value.text);
                              textFieldController.clear();
                            }
                          : null,
                    );
                  },
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Divider(),
          ),
          Expanded(
            child: Consumer(
              builder: (context, ref, _) {
                final todos = ref.watch(homeProvider);

                return ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return Dismissible(
                      key: Key('TodoItem.${todo.id}'),
                      background: const ColoredBox(color: Colors.red),
                      onDismissed: (_) =>
                          ref.read(homeProvider.notifier).remoteTodo(todo.id),
                      child: ListTile(
                        title: Text(todo.name),
                        onTap: () => ref
                            .read(homeProvider.notifier)
                            .toggleComplete(todo.id),
                        trailing: Checkbox(
                          value: todo.isCompleted,
                          onChanged: (_) => ref
                              .read(homeProvider.notifier)
                              .toggleComplete(todo.id),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
