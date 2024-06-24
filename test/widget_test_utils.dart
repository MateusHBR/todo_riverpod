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
