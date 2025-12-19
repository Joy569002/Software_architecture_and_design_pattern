import 'package:postgres_singleton_pattern/threadsafe_singleton.dart';

void main() async {
  ThreadsafeSingleton d = await ThreadsafeSingleton.instance;
  await d.intitialize();
  d.executeInTransaction(
    '001',
    '''INSERT INTO employer (name, surname, business, phonenumber) VALUES 
  ('Joy', 'Smith', 'Construction Co', '555-0101'),
  ('joy01', 'Garcia', 'Tech Solutions', '555-0102')''',
  );
  final res = d.activeTransactions;
  print(res);
}
