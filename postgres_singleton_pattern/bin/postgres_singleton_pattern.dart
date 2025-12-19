import 'package:postgres_singleton_pattern/postgres_singleton_pattern.dart';

void main(List<String> arguments) async {
  DatabaseManager d = DatabaseManager.instance;
  await d.intitializeConnection();
  await d.executeQuery('select * from employer e');
  await d.executeQuery('select * from employer e');
}
