part of 'employee_bloc.dart';

@immutable

abstract class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object?> get props => [];
}

class EmployeeLoadingState extends EmployeeState {}

class EmployeeLoadedState extends EmployeeState {
  final List<Employee> employees;

  EmployeeLoadedState(this.employees);

  @override
  List<Object?> get props => [employees];
    List<Employee> removeEmployee(Employee employee) {
    return List<Employee>.from(employees)..remove(employee);
  }
}

class EmployeeDeletedState extends EmployeeState {}

class EmployeeErrorState extends EmployeeState {
  final String errorMessage;

  EmployeeErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}