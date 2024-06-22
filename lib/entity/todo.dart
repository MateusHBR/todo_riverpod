import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
final class Todo extends Equatable {
  const Todo({
    required this.id,
    required this.name,
    this.isCompleted = false,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      name: json['name'],
      isCompleted: json['is_completed'],
    );
  }

  final String id;
  final String name;
  final bool isCompleted;

  @override
  List<Object> get props => [
        id,
        name,
        isCompleted,
      ];

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_completed': isCompleted,
    };
  }
}
