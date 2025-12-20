import '../userAbstractClass.dart';

class PartTimeEmployee extends User {
  double hourlyRate;
  int hoursWorked = 160;
  PartTimeEmployee({super.id, required super.name, required this.hourlyRate});
  @override
  double calculateSalary() => hourlyRate * hoursWorked;
}
