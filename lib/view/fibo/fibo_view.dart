import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod/view/fibo/provider/fibo_provider.dart';

class FiboView extends StatefulWidget {
  const FiboView({super.key});

  @override
  State<StatefulWidget> createState() => _FiboViewState();
}

class _FiboViewState extends State<FiboView> {
  final textFieldController = TextEditingController();
  int _lastInput = 0;

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('FIBO'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: textFieldController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              Consumer(
                builder: (context, ref, _) {
                  final state = ref.watch(fiboProvider);

                  return ValueListenableBuilder(
                      valueListenable: textFieldController,
                      builder: (context, value, _) {
                        return ElevatedButton(
                          onPressed: state is FiboProcessing ||
                                  value.text.isEmpty
                              ? null
                              : () {
                                  _lastInput = int.parse(
                                    textFieldController.text,
                                  );
                                  ref.read(fiboProvider.notifier).calculateFibo(
                                        _lastInput,
                                      );
                                  textFieldController.clear();
                                },
                          child: const Text('Process'),
                        );
                      });
                },
              ),
              Expanded(
                child: Consumer(
                  builder: (context, ref, _) {
                    final state = ref.watch(fiboProvider);
                    ref.listen<Exception?>(
                      fiboErrorProvider,
                      (_, error) {
                        if (error != null) {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              const SnackBar(
                                content: Text("Failed to process fibo"),
                              ),
                            );
                        }
                      },
                    );

                    return switch (state) {
                      FiboInitial() => const SizedBox(),
                      FiboProcessing() => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      FiboProcessed(:final result) => Center(
                          child: Text(
                            "The fibo of $_lastInput is: $result",
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                        ),
                    };
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
