import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test/test.dart';
import 'package:todo_riverpod/service/uuid/uuid_service.dart';
import 'package:uuid/uuid.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_riverpod/entity/todo.dart';
import 'package:todo_riverpod/service/local_storage/local_storage.dart';
import 'package:todo_riverpod/view/home/provider/todo_provider.dart';

import '../../../provider_test_utils.dart';

class LocalStorageMock extends Mock implements LocalStorage {}

class UuidMock extends Mock implements Uuid {}

void main() {
  group('TodoNotifier', () {
    late LocalStorageMock localStorageMock;
    late UuidMock uuidMock;

    setUpAll(() {
      localStorageMock = LocalStorageMock();
      uuidMock = UuidMock();
    });

    setUp(() {
      when(
        () => localStorageMock.get('todos'),
      ).thenAnswer((_) async => null);
    });

    tearDown(() {
      <Mock>[
        localStorageMock,
        uuidMock,
      ].forEach(reset);
    });

    ProviderContainer buildTodoProviderContainer() {
      return createContainer(
        overrides: [
          uuidServiceProvider.overrideWithValue(uuidMock),
          localStorageServiceProvider.overrideWithValue(localStorageMock),
        ],
      );
    }

    group('build', () {
      test(
        'should build properly todoProvider with filles state from localStorageService',
        () async {
          const expected = [
            Todo(
              id: 'uid',
              name: 'custom todo',
              isCompleted: true,
            )
          ];
          when(
            () => localStorageMock.get('todos'),
          ).thenAnswer((_) async => jsonEncode(expected));

          final container = buildTodoProviderContainer();

          await expectLater(
            container.read(asyncTodosProvider.future),
            completion(expected),
          );

          verify(
            () => localStorageMock.get('todos'),
          ).called(1);
        },
      );
    });

    group('addTodo', () {
      test('should add todo as queue and update storage', () async {
        const newTodoId = 'some-uuid';
        when(uuidMock.v4).thenReturn(newTodoId);
        when(
          () => localStorageMock.save(
            key: any(named: 'key'),
            data: any(named: 'data'),
          ),
        ).thenAnswer((_) async {});

        final container = buildTodoProviderContainer();
        final todoSubscription = container.listen(
          asyncTodosProvider.notifier,
          (_, __) {},
        );
        var expected = const [
          Todo(
            id: newTodoId,
            name: 'awesome name',
          )
        ];

        todoSubscription.read().addTodo('awesome name');
        expect(
          container.read(asyncTodosProvider).asData!.value,
          expected,
        );
        verify(
          () => localStorageMock.save(
            key: 'todos',
            data: jsonEncode(expected),
          ),
        ).called(1);

        const newTodoId2 = 'some-uuid2';
        when(uuidMock.v4).thenReturn(newTodoId2);
        expected = const [
          Todo(
            id: newTodoId2,
            name: 'second task',
          ),
          Todo(
            id: newTodoId,
            name: 'awesome name',
          ),
        ];

        todoSubscription.read().addTodo('second task');
        expect(
          container.read(asyncTodosProvider).asData!.value,
          expected,
        );
        verify(
          () => localStorageMock.save(
            key: 'todos',
            data: jsonEncode(expected),
          ),
        ).called(1);
      });
    });

    group('removeTodo', () {
      const seed = [
        Todo(
          id: 'uid',
          name: 'custom todo',
          isCompleted: true,
        ),
        Todo(
          id: 'uid2',
          name: 'custom todo 2',
          isCompleted: false,
        ),
        Todo(
          id: 'uid3',
          name: 'custom todo 3',
          isCompleted: true,
        ),
      ];

      setUp(() {
        when(
          () => localStorageMock.get('todos'),
        ).thenAnswer((_) async => jsonEncode(seed));
        when(
          () => localStorageMock.save(
            key: 'todos',
            data: any(named: 'data'),
          ),
        ).thenAnswer((_) async {});
      });

      test(
        'should remove todos based on ID and update storage',
        () async {
          final container = buildTodoProviderContainer();
          final todoSubscription = container.listen(
            asyncTodosProvider.notifier,
            (_, __) {},
          );

          await container.read(asyncTodosProvider.future);
          var expected = seed;
          await expectLater(
            container.read(asyncTodosProvider.future),
            completion(expected),
          );

          expected = const [
            Todo(
              id: 'uid',
              name: 'custom todo',
              isCompleted: true,
            ),
            Todo(
              id: 'uid3',
              name: 'custom todo 3',
              isCompleted: true,
            )
          ];
          todoSubscription.read().removeTodo('uid2');
          await expectLater(
            container.read(asyncTodosProvider.future),
            completion(expected),
          );
          verify(
            () => localStorageMock.save(
              key: 'todos',
              data: jsonEncode(expected),
            ),
          ).called(1);

          expected = const [
            Todo(
              id: 'uid',
              name: 'custom todo',
              isCompleted: true,
            ),
          ];
          todoSubscription.read().removeTodo('uid3');
          await expectLater(
            container.read(asyncTodosProvider.future),
            completion(expected),
          );
          verify(
            () => localStorageMock.save(
              key: 'todos',
              data: jsonEncode(expected),
            ),
          ).called(1);

          expected = const [];
          todoSubscription.read().removeTodo('uid');
          await expectLater(
            container.read(asyncTodosProvider.future),
            completion(expected),
          );
          verify(
            () => localStorageMock.save(
              key: 'todos',
              data: jsonEncode(expected),
            ),
          ).called(1);
        },
      );

      test(
        'should do nothing when id does not exists',
        () async {
          final container = buildTodoProviderContainer();
          final todoSubscription = container.listen(
            asyncTodosProvider.notifier,
            (_, __) {},
          );

          await container.read(asyncTodosProvider.future);
          await expectLater(
            container.read(asyncTodosProvider.future),
            completion(seed),
          );

          todoSubscription.read().removeTodo('inexistent id');
          await expectLater(
            container.read(asyncTodosProvider.future),
            completion(seed),
          );
          verify(
            () => localStorageMock.save(
              key: 'todos',
              data: jsonEncode(seed),
            ),
          ).called(1);
        },
      );
    });
  });
}
