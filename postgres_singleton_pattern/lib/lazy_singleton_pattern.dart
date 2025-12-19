import 'package:postgres/postgres.dart';

class LazySingletonPattern {
  static LazySingletonPattern? _instance;
  Connection? _connection;
  final List<String> _queryHistory = [];
  LazySingletonPattern._internal() {
    print("Lazy sing lteont created in frist use");
  }
  static LazySingletonPattern get instance {
    _instance ??= LazySingletonPattern._internal();
    return _instance!;
  }

  List<String> get queryHistory => List.unmodifiable(_queryHistory);
  Future<void> connect() async {
    if (_connection == null) {
      print("Initializing connectio lazy");
      _connection ??= await Connection.open(
        Endpoint(
          host: 'localhost',
          database: 'temp',
          username: '',
          password: '',
        ),
        settings: ConnectionSettings(sslMode: SslMode.disable),
      );
      print("Database connected (Lazy singleton)");
    }
  }

  Future<dynamic> getData(String query) async {
    final result = await _connection!.execute(query);
    return result;
  }
}
