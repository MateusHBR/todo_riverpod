import 'package:meta/meta.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/entity/todo.dart';
import 'package:todo_riverpod/view/home/provider/todo_provider.dart';

class TodoNotifierMock extends TodoNotifier with Mock {
  @protected
  @override
  AsyncValue<List<Todo>> get state => const AsyncValue.loading();

  @override
  set state(AsyncValue<List<Todo>> newState) {
    super.state = newState;
  }
}
