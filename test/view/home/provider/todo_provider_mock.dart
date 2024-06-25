import 'package:mockito/mockito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/entity/todo.dart';
import 'package:todo_riverpod/view/home/provider/todo_provider.dart';

class TodoNotifierMock extends AutoDisposeAsyncNotifier<List<Todo>>
    with Mock
    implements TodoNotifier {}
