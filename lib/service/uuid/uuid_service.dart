import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final uuidServiceProvider = Provider<Uuid>(
  (_) => const Uuid(),
);
