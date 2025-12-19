import 'package:postgres_singleton_pattern/lazy_singleton_pattern.dart';

void main() async {
  LazySingletonPattern d = LazySingletonPattern.instance;
  await d.connect();
  final res = await d.getData('Select * from employer');
  print(res);
}
