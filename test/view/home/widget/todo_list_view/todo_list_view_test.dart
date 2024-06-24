import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_riverpod/entity/todo.dart';
import 'package:todo_riverpod/view/home/provider/todo_provider.dart';
import 'package:todo_riverpod/view/home/widget/todo_list_view/todo_list_view.dart';

import '../../../../named_variants.dart';
import '../../../../widget_test_utils.dart';
import '../../provider/todo_provider_mock.dart';

void main() {
  group('TodoListView', () {
    Future<void> setupWidget(
      WidgetTester tester, {
      TodoNotifier? todoNotifier,
    }) async {
      await loadWidget(
        tester,
        overrides: [
          asyncTodosProvider.overrideWith(
            () => todoNotifier ?? TodoNotifierMock(),
          ),
        ],
        widget: const TodoListView(),
      );
    }

    final stateVariants = NamedValueVariants(
      values: [
        (
          testLabel: 'loaded',
          state: const AsyncValue.data([
            Todo(id: 'id1', name: 'name1'),
            Todo(id: 'id2', name: 'name2'),
            Todo(id: 'id3', name: 'name3'),
          ]),
          listViewFinder: findsOne,
          loadingIndicatorFinder: findsNothing,
          errorFinder: findsNothing,
        ),
        (
          testLabel: 'load in progress',
          state: const AsyncValue<List<Todo>>.loading(),
          listViewFinder: findsNothing,
          loadingIndicatorFinder: findsOne,
          errorFinder: findsNothing,
        ),
        (
          testLabel: 'error',
          state: AsyncValue<List<Todo>>.error(
            Exception(),
            StackTrace.fromString(''),
          ),
          listViewFinder: findsNothing,
          loadingIndicatorFinder: findsNothing,
          errorFinder: findsOne,
        ),
      ],
      describe: (v) => v.testLabel,
    );
    testWidgets(
      'should render properly',
      variant: stateVariants,
      (tester) async {
        final currentVariant = stateVariants.currentValue;
        final todoNotifier = TodoNotifierMock();

        await setupWidget(
          tester,
          todoNotifier: todoNotifier,
        );

        todoNotifier.state = currentVariant.state;
        await tester.pump();

        expect(
          find.byType(ListView),
          currentVariant.listViewFinder,
        );
        expect(
          find.byType(CircularProgressIndicator),
          currentVariant.loadingIndicatorFinder,
        );
        expect(
          find.byKey(const Key('ErrorTodoVisible')),
          currentVariant.errorFinder,
        );
      },
    );
  });
}
