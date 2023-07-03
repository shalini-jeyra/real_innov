import 'package:hive/hive.dart';

import '../models/employee.dart';

class EmployeeService {
  static const String _boxName = 'employees';

  Future<void> open() async {
    await Hive.openBox<Employee>(_boxName);
  }

  Box<Employee> _getBox() {
    return Hive.box<Employee>(_boxName);
  }

  Future<List<Employee>> getEmployees() async {
    final box = _getBox();
    return box.values.toList();
  }

  Future<void> addEmployee(Employee employee) async {
    final box = _getBox();
    await box.add(employee);
  }
Future<void> updateEmployee(Employee employee) async {
  final box = _getBox();
  final employees = await getEmployees();
  final index = employees.indexWhere((emp) => emp.id == employee.id);
  if (index != -1) {
    employees[index] = employee;
    await box.putAll(employees.asMap());
  }
}




Future<void> deleteEmployee(Employee employee) async {
  final box = _getBox();
  await box.delete(employee.key);
}


  Future<void> close() async {
    await Hive.close();
  }
}
