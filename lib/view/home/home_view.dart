import 'package:flutter/material.dart';

import 'widget/todo_list_view/todo_list_view.dart';
import 'widget/todo_text_field_section/todo_text_field_section.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
