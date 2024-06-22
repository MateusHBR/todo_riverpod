import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/view/home/provider/todo_provider.dart';

class TodoTextFieldSection extends ConsumerWidget {
  const TodoTextFieldSection({
    super.key,
    required this.textFieldController,
  });

  final TextEditingController textFieldController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
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
                            .read(asyncTodosProvider.notifier)
                            .addTodo(value.text);
                        textFieldController.clear();
                      }
                    : null,
              );
            },
          ),
        ],
      ),
    );
  }
}
