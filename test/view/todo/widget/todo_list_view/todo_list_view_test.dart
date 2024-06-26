import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_riverpod/entity/todo.dart';
import 'package:todo_riverpod/view/todo/provider/todo_provider.dart';
import 'package:todo_riverpod/view/todo/widget/todo_list_view/todo_list_view.dart';

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
        widget: const Padding(
          padding: EdgeInsets.all(10.0),
          child: TodoListView(),
        ),
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

    testWidgets(
      'should trigger toggleComplete when item pressed or when CheckBox is pressed',
      (tester) async {
        final todoNotifier = TodoNotifierMock();

        await setupWidget(
          tester,
          todoNotifier: todoNotifier,
        );

        todoNotifier.state = const AsyncValue.data([
          Todo(id: 'id1', name: 'name1'),
          Todo(id: 'id2', name: 'name2'),
          Todo(id: 'id3', name: 'name3'),
        ]);
        await tester.pump();

        await tester.tap(find.byKey(const Key('TodoItem.id1')));
        verify(todoNotifier.toggleComplete('id1')).called(1);
        verifyNever(todoNotifier.toggleComplete('id2'));
        verifyNever(todoNotifier.toggleComplete('id3'));

        await tester.tap(find.descendant(
          of: find.byKey(const Key('TodoItem.id2')),
          matching: find.byType(Checkbox),
        ));
        verifyNever(todoNotifier.toggleComplete('id1'));
        verify(todoNotifier.toggleComplete('id2')).called(1);
        verifyNever(todoNotifier.toggleComplete('id3'));
      },
    );

    testWidgets(
      'should trigger removeTodo when item is dismissed',
      (tester) async {
        final todoNotifier = TodoNotifierMock();

        await setupWidget(
          tester,
          todoNotifier: todoNotifier,
        );

        todoNotifier.state = const AsyncValue.data([
          Todo(id: 'id1', name: 'name1'),
          Todo(id: 'id2', name: 'name2'),
          Todo(id: 'id3', name: 'name3'),
        ]);
        await tester.pumpAndSettle();

        Dismissible item = tester.widget(find.byKey(const Key('TodoItem.id1')));
        await tester.dismissElement(
          find.byWidget(item),
          gestureDirection: AxisDirection.left,
        );
        await tester.pumpAndSettle();
        verify(todoNotifier.removeTodo('id1')).called(1);
        verifyNever(todoNotifier.removeTodo('id2'));
        verifyNever(todoNotifier.removeTodo('id3'));

        item = tester.widget(find.byKey((const Key('TodoItem.id2'))));
        await tester.dismissElement(
          find.byWidget(item),
          gestureDirection: AxisDirection.right,
        );
        await tester.pumpAndSettle();
        verifyNever(todoNotifier.removeTodo('id1'));
        verify(todoNotifier.removeTodo('id2')).called(1);
        verifyNever(todoNotifier.removeTodo('id3'));

        expect(find.byKey((const Key('TodoItem.id1'))), findsNothing);
        expect(find.byKey((const Key('TodoItem.id2'))), findsNothing);
        expect(find.byKey((const Key('TodoItem.id3'))), findsOne);
      },
    );
  });
}
