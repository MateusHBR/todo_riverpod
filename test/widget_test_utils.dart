import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> loadWidget(
  WidgetTester tester, {
  Widget? widget,
  List<Override> overrides = const [],
  List<ProviderObserver>? observers,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      observers: observers,
      child: MaterialApp(
        home: Scaffold(
          body: widget ?? const SizedBox(),
        ),
      ),
    ),
  );
}

extension WidgetTesterExtensions on WidgetTester {
  Future<void> dismissElement(
    Finder finder, {
    required AxisDirection gestureDirection,
    double initialOffsetFactor = 0.0,
  }) async {
    final Offset delta = switch (gestureDirection) {
      AxisDirection.left => const Offset(-300, 0.0),
      AxisDirection.right => const Offset(300, 0.0),
      AxisDirection.up => const Offset(0.0, -300),
      AxisDirection.down => const Offset(0.0, 300),
    };
    await fling(
      finder,
      delta,
      1000.0,
      initialOffset: delta * initialOffsetFactor,
    );
  }
}
