import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';

class NamedValueVariants<T> extends TestVariant<T> {
  NamedValueVariants({
    required List<T> values,
    required this.describe,
  }) : _values = values;

  late T _currentValue;
  final List<T> _values;
  final String Function(T value) describe;

  T get currentValue => _currentValue;

  @override
  Iterable<T> get values => _values;

  T randomValue() => _values[math.Random().nextInt(_values.length)];

  @override
  String describeValue(T value) => describe(value);

  @override
  Future<T> setUp(T value) async => _currentValue = value;

  @override
  Future<void> tearDown(T value, void memento) async {}
}
