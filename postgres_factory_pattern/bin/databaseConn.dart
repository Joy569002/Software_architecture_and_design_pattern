import 'package:postgres/postgres.dart';

class DatabaseConnection {
  static Connection? _conn;
  static Future<Connection> getConn() async {
    if (_conn == null || !_conn!.isOpen) {
      _conn = await Connection.open(
        Endpoint(
          host: 'localhost',
          database: 'temp',
          username: 'tanjim',
          password: '241198',
        ),
      );
      await _conn!.execute('''
        CREATE TABLE IF NOT EXISTS users (
          id SERIAL PRIMARY KEY,
          name VARCHAR(100),
          type VARCHAR(50),
          salary DECIMAL(10,2),
          hourly_rate DECIMAL(5,2),
          commission_rate DECIMAL(5,2)
        );
      ''');
      await _conn!.execute('''
        CREATE TABLE IF NOT EXISTS notifications (
          id SERIAL PRIMARY KEY,
          type VARCHAR(50),
          recipient VARCHAR(255),
          message TEXT,
          sent_at TIMESTAMP DEFAULT NOW()
        );
      ''');
      await _conn!.execute('''
        CREATE TABLE IF NOT EXISTS products (
          id SERIAL PRIMARY KEY,
          type VARCHAR(50),
          name VARCHAR(100),
          price DECIMAL(10,2),
          weight DECIMAL(10,2),
          digital_url TEXT
        );
      ''');
    }
    return _conn!;
  }

  static Future<void> close() async {
    await _conn?.close();
  }
}
