import 'package:postgres/postgres.dart';

class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager._internal();
  final Map<String, dynamic> _queryCache = {};
  Connection? _connection;
  int _queryCount = 0;
  DatabaseManager._internal() {
    print("Eager Database created");
  }
  static DatabaseManager get instance => _instance;
  int get getQueryCount => _queryCount;
  Map<String, dynamic> get cache => Map.unmodifiable(_queryCache);
  Future<void> intitializeConnection() async {
    _connection ??= await Connection.open(
      Endpoint(
        host: 'localhost',
        database: 'temp',
        username: 'tanjim',
        password: '241198',
      ),
      settings: ConnectionSettings(sslMode: SslMode.disable),
    );
  }

  Future<List<List<dynamic>>> executeQuery(String query) async {
    _queryCount++;
    if (query.toUpperCase().startsWith('SELECT') && !query.contains('NOW()')) {
      print(query);
      if (_queryCache.containsKey(query)) {
        print('⚡ Serving from cache: $query');
        return _queryCache[query];
      }

      final result = await _connection!.execute(query);
      _queryCache[query] = result;
      return result;
    }

    return await _connection!.execute(query);
  }
}
