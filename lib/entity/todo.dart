import 'package:meta/meta.dart';

@immutable
final class Todo {
  const Todo({
    required this.id,
    required this.name,
    this.isCompleted = false,
  });

  final String id;
  final String name;
  final bool isCompleted;

  Todo copyWith({
    String? id,
    String? name,
    bool? isCompleted,
  }) {
    return Todo(
      id: id ?? this.id,
      name: name ?? this.name,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
