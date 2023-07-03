part of 'employee_bloc.dart';

@immutable

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object?> get props => [];
}

class LoadEmployeeEvent extends EmployeeEvent {}

class AddEmployeeEvent extends EmployeeEvent {
  final Employee employee;

  AddEmployeeEvent(this.employee);

  @override
  List<Object?> get props => [employee];
}

class UpdateEmployeeEvent extends EmployeeEvent {
  final Employee oldEmployee;
  final Employee newEmployee;

  UpdateEmployeeEvent(this.oldEmployee, this.newEmployee);

  @override
  List<Object?> get props => [oldEmployee, newEmployee];
}

class DeleteEmployeeEvent extends EmployeeEvent {
  final Employee employee;

  DeleteEmployeeEvent(this.employee);

  @override
  List<Object?> get props => [employee];
}
