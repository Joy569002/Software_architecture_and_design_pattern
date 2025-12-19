import 'package:postgres/postgres.dart';
import 'package:synchronized/synchronized.dart';

class ThreadsafeSingleton {
  static ThreadsafeSingleton? _instance;
  static final Lock _lock = Lock();
  Connection? _connection;
  final Set<String> _activeTransfer = {};
  ThreadsafeSingleton._internal() {
    print("Thread safe singleton created");
  }
  static Future<ThreadsafeSingleton> get instance async {
    if (_instance == null) {
      await _lock.synchronized(() async {
        _instance ??= ThreadsafeSingleton._internal();
      });
    }
    return _instance!;
  }

  Set<String> get activeTransactions => Set.unmodifiable(_activeTransfer);
  Future<void> intitialize() async {
    await _lock.synchronized(() async {
      print("Thread safe intialization strated");
      _connection = await Connection.open(
        Endpoint(
          host: 'localhost',
          database: 'temp',
          username: 'tanjim',
          password: '241198',
        ),
      );
    });
  }

  Future<void> executeInTransaction(String transactionId, String query) async {
    await _lock.synchronized(() async {
      _activeTransfer.add(transactionId);
      print('💳 Starting transaction: $transactionId');

      try {
        await _connection!.runTx((ctx) async {
          await ctx.execute(query);
          await Future.delayed(Duration(milliseconds: 100)); // Simulate work
        });
        print('✅ Transaction completed: $transactionId');
      } finally {
        _activeTransfer.remove(transactionId);
      }
    });
  }
}
