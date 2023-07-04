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
Future<void> updateEmployee(Employee oldEmployee, Employee newEmployee) async {
  final box = _getBox();
  final List<Employee> employees = box.values.toList();
  employees.removeWhere((emp) => emp.id == oldEmployee.id); 
  
  await box.clear(); 
  
  for (final employee in employees) {
    await box.put(employee.id, employee);
  }
  
  await box.put(newEmployee.id, newEmployee); 
  print(box.values);
}



Future<void> deleteEmployee(Employee employee) async {
  final box = _getBox();
  await box.delete(employee.key);
}


  Future<void> close() async {
    await Hive.close();
  }
}
