import '../userAbstractClass.dart';

class FullTimeEmployee extends User {
  double salary;
  FullTimeEmployee({super.id, required super.name, required this.salary});

  @override
  double calculateSalary() => salary;
}
