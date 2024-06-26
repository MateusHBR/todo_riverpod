import 'dart:async';
import 'dart:isolate';

int _fib(int n) {
  if (n == 1 || n == 0) {
    return n;
  }
  return _fib(n - 2) + _fib(n - 1);
}

class FiboWorker {
  final Completer<void> _isolateReady = Completer.sync();
  late SendPort _isolatePort;
  final _resultController = StreamController<int>.broadcast();

  Future<Stream<int>> spawn() async {
    final receivePort = ReceivePort();
    receivePort.listen(_handleResponseFromIsolate);
    await Isolate.spawn(_startRemoteIsolate, receivePort.sendPort);
    return _resultController.stream;
  }

  void _handleResponseFromIsolate(dynamic data) {
    if (data is SendPort) {
      _isolatePort = data;
      _isolateReady.complete();
      return;
    }

    if (data is int) {
      _resultController.add(data);
    }
  }

  static void _startRemoteIsolate(SendPort port) {
    final receivePort = ReceivePort();
    port.send(receivePort.sendPort);
    receivePort.listen((dynamic data) {
      if (data is int) {
        print("WORKER CALCULATING FIBO OF: $data");
        port.send(_fib(data));
      }
    });
  }

  Future<void> calculateFibonnaci(int value) async {
    await _isolateReady.future;
    _isolatePort.send(value);
  }
}
