import 'dart:async';

import 'package:postgres/postgres.dart';

class AsyncSingletonPattern {
  static AsyncSingletonPattern? _instance;
  static Completer<AsyncSingletonPattern>? _completer;
  Connection? _conn;
  final Map<int, String> _userCache = {};
  DateTime? _lastSync;
  AsyncSingletonPattern._internal();
  static Future<AsyncSingletonPattern> get instance async {
    if (_instance != null) return _instance!;
    if (_completer != null) {
      return _completer!.future;
    }
    _completer = Completer<AsyncSingletonPattern>();
    try {
      _instance = AsyncSingletonPattern._internal();
      await _instance!._heavyInitialization();
      _completer!.complete(_instance);
    } catch (e) {
      _completer!.completeError(e);
      _completer = null;
      rethrow;
    }
    return _instance!;
  }

  Future<void> _heavyInitialization() async {
    _conn = await Connection.open(
      Endpoint(
        host: 'localhost',
        database: 'temp',
        username: 'tanjim',
        password: '241198',
      ),
    );
  }

  Future<void> _syncUserCache() async {
    final result = await _conn!.execute('select id from users');
    for (var row in result) {
      _userCache[row[0] as int] = row[1] as String;
    }
    _lastSync = DateTime.now();
  }

  Future<Map<String, dynamic>> getUserInfo(int userId) async {
    if (_userCache.containsKey(userId)) {
      return {
        'id': userId,
        'name': _userCache[userId],
        'source': 'cache',
        'last_sync': _lastSync,
      };
    }

    final result = await _conn!.execute('SELECT * FROM users WHERE id = @id');

    if (result.isNotEmpty) {
      _userCache[userId] = result[0][1] as String;
      return {
        'id': result[0][0],
        'name': result[0][1],
        'email': result[0][2],
        'source': 'database',
      };
    }

    throw Exception('User not found');
  }
}
