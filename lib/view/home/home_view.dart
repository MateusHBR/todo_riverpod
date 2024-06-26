import 'package:flutter/material.dart';
import 'package:todo_riverpod/view/fibo/fibo_view.dart';
import 'package:todo_riverpod/view/todo/todo_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const [
        TodoView(),
        FiboView(),
      ][_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (newPage) => setState(() => _selectedIndex = newPage),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_outlined),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate_outlined),
            label: 'Fibonacci',
          ),
        ],
      ),
    );
  }
}
