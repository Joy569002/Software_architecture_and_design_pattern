import '../userAbstractClass.dart';

class CommissionEmployee extends User {
  double commissionRate;
  double salesAmount = 50000;

  CommissionEmployee({
    super.id,
    required super.name,
    required this.commissionRate,
  });

  @override
  double calculateSalary() => salesAmount * commissionRate;
}
