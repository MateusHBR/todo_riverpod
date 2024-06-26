import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/view/fibo/worker/fibo_worker.dart';

final fiboProvider = StateNotifierProvider.autoDispose<FiboNotifier, FiboState>(
  FiboNotifier.new,
);

final fiboErrorProvider = StateProvider<Exception?>(
  (_) => null,
);

class FiboNotifier extends StateNotifier<FiboState> {
  FiboNotifier(this.ref) : super(const FiboInitial());

  final Ref ref;
  FiboWorker? worker;

  Future<void> calculateFibo(int value) async {
    state = const FiboProcessing();
    if (worker == null) {
      worker = FiboWorker();
      (await worker!.spawn()).listen((data) {
        state = FiboProcessed(result: data);
      });
    }

    await worker!.calculateFibonnaci(value);
  }
}

sealed class FiboState extends Equatable {
  const FiboState();

  @override
  List<Object?> get props => [];
}

final class FiboInitial extends FiboState {
  const FiboInitial();
}

final class FiboProcessing extends FiboState {
  const FiboProcessing();
}

final class FiboProcessed extends FiboState {
  const FiboProcessed({
    required this.result,
  });

  final int result;

  @override
  List<Object?> get props => [
        result,
      ];
}
