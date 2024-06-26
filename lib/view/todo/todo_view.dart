import 'package:flutter/material.dart';

import '../todo/widget/todo_list_view/todo_list_view.dart';
import '../todo/widget/todo_text_field_section/todo_text_field_section.dart';

class TodoView extends StatefulWidget {
  const TodoView({super.key});

  @override
  State<StatefulWidget> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
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
          TodoTextFieldSection(textFieldController: textFieldController),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Divider(),
          ),
          const Expanded(child: TodoListView()),
        ],
      ),
    );
  }
}
