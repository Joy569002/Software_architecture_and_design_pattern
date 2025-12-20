import 'databaseConn.dart';
import '../bin/employerClasses/commissionemp.dart';
import '../bin/employerClasses/fulltimeemp.dart';
import '../bin/employerClasses/parttimeemp.dart';

abstract class User {
  int? id;
  String name;
  double calculateSalary();
  User({this.id, required this.name});
  Future<void> save() async {
    final conn = await DatabaseConnection.getConn();
    if (id == null) {
      final res = await conn.execute(
        'INSERT INTO users(name, type, salary, hourly_rate, commission_rate) VALUES (@name, @type, @salary, @hourly, @commission) RETURNING id',
        parameters: {
          'name': name,
          'type': runtimeType.toString(),
          'salary': this is FullTimeEmployee
              ? (this as FullTimeEmployee).salary
              : null,
          'hourly': this is PartTimeEmployee
              ? (this as PartTimeEmployee).hourlyRate
              : null,
          'commission': this is CommissionEmployee
              ? (this as CommissionEmployee).commissionRate
              : null,
        },
      );
      id = res[0][0] as int;
    }
  }

  static Future<User> fromDatabase(int id) async {
    final connection = await DatabaseConnection.getConn();
    final result = await connection.execute(
      'SELECT * FROM users WHERE id = @id',
      parameters: {'id': id},
    );

    if (result.isEmpty) throw Exception('User not found');

    final row = result[0];
    final type = row[2] as String;
    final name = row[1] as String;

    switch (type) {
      case 'FullTimeEmployee':
        return FullTimeEmployee(id: id, name: name, salary: row[3] as double);
      case 'PartTimeEmployee':
        return PartTimeEmployee(
          id: id,
          name: name,
          hourlyRate: row[4] as double,
        );
      case 'CommissionEmployee':
        return CommissionEmployee(
          id: id,
          name: name,
          commissionRate: row[5] as double,
        );
      default:
        throw Exception('Unknown user type');
    }
  }
}
