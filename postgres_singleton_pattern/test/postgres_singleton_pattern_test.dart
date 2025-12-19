import 'package:postgres_singleton_pattern/postgres_singleton_pattern.dart';
import 'package:test/test.dart';

void main() {
  test('calculate', () {
    expect(calculate(), 42);
  });
}
