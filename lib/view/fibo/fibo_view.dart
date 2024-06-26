import 'package:flutter/material.dart';

class FiboView extends StatefulWidget {
  const FiboView({super.key});

  @override
  State<StatefulWidget> createState() => _FiboViewState();
}

class _FiboViewState extends State<FiboView> {
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
        title: const Text('FIBO'),
      ),
      body: const Column(
        children: [],
      ),
    );
  }
}
