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
}

class EmployeeErrorState extends EmployeeState {
  final String errorMessage;

  EmployeeErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}